Rails.application.routes.draw do
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    
    root 'welcomes#index'
    get "/checkout" => "welcomes#checkout_page", as: "checkout"
    post "/make_payment" => "welcomes#make_payment", as: "make_payment"
    post "/check_payment_status/:id" => "welcomes#check_payment_status"

    post "/await_payment_response_backend/:id" => "welcomes#await_payment_response_backend", as: "await_payment_response_backend"
    get "/await_payment_response/:id" => "welcomes#await_payment_response", as: "await_payment_response"
    get "/payment_response_success/:id" => "welcomes#payment_response_success", as: "payment_response_success"
    get "/payment_response_fail/:id" => "welcomes#payment_response_fail", as: "payment_response_fail"

    resources :payments
end