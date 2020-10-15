Rails.application.routes.draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    root 'welcomes#index'
    post "/payment" => "welcomes#payment", as: "payment"
    get "/payment_response" => "welcomes#payment_response", as: "payment_response"
end
