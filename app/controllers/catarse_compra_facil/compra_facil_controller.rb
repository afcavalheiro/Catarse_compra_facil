class CatarseCompraFacil::CompraFacilController < ApplicationController
  skip_before_filter :force_http
  SCOPE = "projects.backers.checkout"
  layout :false

  def review
  end

  def pay
    begin
      @comprafacil = CatarseCompraFacil::CompraFacil.new({
          :origin => backer.project.id,
          :value => backer.value,
          :info => "" })

      @comprafacil.send_order!

      backer.update_attributes payment_method: 'CompraFacil', entity: @comprafacil.entity, reference: @comprafacil.reference

      flash[:success] = t('sucess_comprafacil', scope: SCOPE)
      redirect_to main_app.project_backer_path(project_id: backer.project.id, id: backer.id)

    rescue Exception => e
      Rails.logger.info "-----> #{e.inspect}"
      flash[:failure] = t('paypal_error', scope: SCOPE)
      return redirect_to main_app.new_project_backer_path(backer.project)
    end

  end

  def backer
    @backer ||= if params['id']
                  PaymentEngines.find_payment(id: params['id'])
                elsif params['txn_id']
                  PaymentEngines.find_payment(payment_id: params['txn_id']) || (params['parent_txn_id'] && PaymentEngines.find_payment(payment_id: params['parent_txn_id']))
                end
  end
end

