class WelcomesController < ApplicationController
    require 'net/http'
    before_action :set_payment, except: [:index, :checkout_page, :make_payment]
    skip_before_action :verify_authenticity_token, :only => [:await_payment_response_backend]
    before_action :set_api

    def index        
    end

    def checkout_page
    end

    def make_payment
        @payment = Payment.create()
        req = Faraday.new do |f|
            f.adapter :net_http
        end

        req = req.post(
            "#{@api_url}api/v3/bills?auto_submit=true", 
            {
                "collection_id": @collection_id,
                "email": "kliwaru@gmail.com",
                "name": "Leon",
                "amount": 200,
                "description": "TEST.",
                "callback_url": "https://billplz-test.herokuapp.com/await_payment_response_backend/#{@payment.id}",
                "redirect_url": "https://billplz-test.herokuapp.com/await_payment_response/#{@payment.id}",
            }.to_json,
            {
                "Authorization" => "Basic #{Base64.encode64(@api_key).chomp}",
                "Content-Type" => "application/json"
            }
        )

        if req.status == 200
            server_resp = JSON.parse(req.body)
            @payment.update(billplz_id: server_resp["id"])
            redirect_to server_resp["url"]
        else
            flash[:error] = "SOMETHING WENT WRONG!"
            redirect_to root_path
        end
    end

    # callback_url from billplz
    def await_payment_response_backend 
        @payment.update(details: params)
        if params["paid"] == "true"
            @payment.update(payment_status: "success")
        elsif params["paid"] == "false"
            @payment.update(payment_status: "failure")
        end
    end

    # redirect url
    def await_payment_response
    end

    # from frontend AJAX
    def check_payment_status
        render :json => { status: @payment.payment_status }
    end

    def payment_response_success
    end

    def payment_response_fail
    end
    
    private
    def set_payment
        @payment = Payment.find(params[:id])
    end

    def set_api
        @api_url = "https://www.billplz-sandbox.com/"
        @api_key = "8a2ab22b-6bea-41ac-a132-10ad130a5712:"
        @collection_id ="g3ttovrw"
    end
end