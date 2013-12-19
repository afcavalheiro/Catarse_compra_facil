begin
  PaymentEngines.register({name: 'comprafacil', review_path: ->(backer){ CatarseCompraFacil::Engine.routes.url_helpers.review_compra_facil_path(backer) }, locale: 'pt'})
rescue Exception => e
  puts "Error while registering payment engine: #{e}"
end
