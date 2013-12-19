require "catarse_compra_facil/engine"
require "savon"

module CatarseCompraFacil

  class CompraFacil

    attr_accessor :origin,
                  :user,
                  :password,
                  :value,
                  :info,
                  :name,
                  :address,
                  :zip_code,
                  :city,
                  :nif,
                  :external_reference,
                  :phone,
                  :email,
                  :user_id_back_office,
                  :reference,
                  :entity,
                  :error,
                  :payment_company

    attr_reader   :user_type, :server_address, :insert_mode

    def initialize(attrs = {})
      attrs.each {|key, value| self.send("#{key}=", value)}
      @user_id_back_office = -1
      self.payment_company = "multibanco"
      self.user_type = 10241
      self.insert_mode = "SaveCompraToBDValor1"
    end

    def payment_company=(payment_company_text)
      if payment_company_text == "multibanco" or payment_company_text == "payshop"
        @payment_company = payment_company_text
        update_server_address
        set_config
      else
        raise "payment_company should be 'multibanco' or 'payshop'"
      end
    end

    def insert_mode=(insert_mode_text)
      if insert_mode_text == "SaveCompraToBD1" or insert_mode_text == "SaveCompraToBD2" or insert_mode_text == "SaveCompraToBDValor1" or insert_mode_text == "SaveCompraToBDValor2"
        @insert_mode = insert_mode_text
      else
        raise "insert_mode should be 'SaveCompraToBD1', 'SaveCompraToBD2', 'SaveCompraToBDValor1' or 'SaveCompraToBDValor2'"
      end
    end

    def user_type=(user_type_number)
      if user_type_number == 11249 || user_type_number == 10241
        @user_type = user_type_number
        update_server_address
      else
        raise "user_type should be 10241 or 11249"
      end
    end

    def send_order!
      client = Savon.client(wsdl: self.server_address)
      message = { :origem => self.origin,
                  "IDCliente" => self.user,
                  :password => self.password,
                  :valor => self.value,
                  :informacao => self.info,
                  "IDUserBackoffice" => self.user_id_back_office.to_s
                  }
      response = client.call(:save_compra_to_bd_valor1, message: message)
      if response.success?
        self.reference = response.to_hash[:save_compra_to_bd_valor1_response][:referencia]
        self.entity = response.to_hash[:save_compra_to_bd_valor1_response][:entidade]
      end


      puts response.to_hash;
    end

    private

    def update_server_address
      if @payment_company == "multibanco"
        @server_address = "https://hm.comprafacil.pt/SIBSClick2/webservice/clicksmsV4.asmx?WSDL" if @user_type == 11249
        @server_address = "https://hm.comprafacil.pt/SIBSClickTeste/webservice/clicksmsV4.asmx?wsdl" if @user_type == 10241
      else
        @server_address = "https://hm.comprafacil.pt/SIBSClick2/webservice/CompraFacilPS.asmx?WSDL" if @user_type == 11249
        @server_address = "https://hm.comprafacil.pt/SIBSClickTeste/webservice/clicksmsV4.asmx?wsdl" if @user_type == 10241
      end
    end

    def set_config
      if PaymentEngines.configuration[:comprafacil_CustomerID] and PaymentEngines.configuration[:comprafacil_password]
        self.user = PaymentEngines.configuration[:comprafacil_CustomerID]
        self.password = PaymentEngines.configuration[:comprafacil_password]
      else
        puts "[PayPal] An API Certificate or API Signature is required to make requests to PayPal"
      end
    end
  end

end
