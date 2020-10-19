class WelcomesController < ApplicationController
    require 'net/http'
    before_action :set_payment, except: [:index, :checkout_page, :make_payment]
    skip_before_action :verify_authenticity_token, :only => [:await_payment_response_backend]

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
            "https://www.billplz-sandbox.com/api/v3/bills?auto_submit=true", 
            {
                "collection_id": "g3ttovrw",
                "email": "kliwaru@gmail.com",
                "name": "Leon",
                "amount": 200,
                "description": "TEST.",
                "callback_url": "https://billplz-test.herokuapp.com/await_payment_response_backend/#{@payment.id}",
                "redirect_url": "https://billplz-test.herokuapp.com/await_payment_response/#{@payment.id}",
            }.to_json,
            {
                "Authorization" => "Basic #{Base64.encode64('8a2ab22b-6bea-41ac-a132-10ad130a5712:').chomp}",
                "Content-Type" => "application/json"
            }
        )
        puts req.status

        if req.status == 200
            server_resp = JSON.parse(req.body)
            @payment.update(billplz_id: server_resp["id"])
            redirect_to server_resp["url"]
        else
            flash[:error] = "SOMETHING WENT WRONG!"
            redirect_to root_path
        end
    end

    def await_payment_response_backend
        @payment.update(details: params)
        p "INCOMING REQUEST ==================================================="
        p @payment
        p params
        p params["billplz"]["paid"]
    end

    def await_payment_response
    end

    def check_payment_status
        render :json => {
            status: @payment.payment_status
        }

        if @payment.payment_status == "success"
            redirect_to payment_response_success_path(@payment)
        elsif @payment.payment_status == "failure"
            redirect_to payment_response_fail_path(@payment)
        end
    end

    def payment_response_success
        req = Faraday.new do |f|
            f.adapter :net_http
        end

        @req = req.get(
            "https://www.billplz-sandbox.com/api/v3/bills/#{@payment.billplz_id}", 
            {},
            {
                "Authorization" => "Basic #{Base64.encode64('8a2ab22b-6bea-41ac-a132-10ad130a5712:').chomp}",
                "Content-Type" => "application/json"
            }
        )

        if @req.status == 200
            @req_body = JSON.parse(@req.body)
        else
            flash[:error] = "SOMETHING WENT WRONG!"
            redirect_to root_path
        end
    end

    def payment_response_fail

    end
    
    private
    def set_payment
        @payment = Payment.find(params[:id])
    end
end

