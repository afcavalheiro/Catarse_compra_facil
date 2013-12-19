CatarseCompraFacil::Engine.routes.draw do
  resources :compra_facil, only: []  do
    collection do
      post :ipn
    end

    member do
      get   :review
      match :pay
      match :success
      match :cancel
    end
  end
end
