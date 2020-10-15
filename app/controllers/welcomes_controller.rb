class WelcomesController < ApplicationController
    require 'net/http'

    def index
        
    end

    # def payment
    #     curl https://www.billplz-sandbox.com/api/v3/bills \
    #     -u 8a2ab22b-6bea-41ac-a132-10ad130a5712: \
    #     -d collection_id=g3ttovrw \
    #     -d description="Maecenas eu placerat ante." \
    #     -d email=kliwaru@gmail.com \
    #     -d name="Sara" \
    #     -d amount=200 \
    #     -d callback_url="https://localhost:3000/"
    # end

    def payment
        
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
                "callback_url": "https://localhost:3000/payment",
                # "reference_1_label": "Bank Code",
                # "reference_1": "BP-FKR01",
                # "redirect_url": "https://www.edumetry.app/",
            }.to_json,
            {
                "Authorization" => "Basic #{Base64.encode64('8a2ab22b-6bea-41ac-a132-10ad130a5712:').chomp}",
                "Content-Type" => "application/json"
            }
        )
        puts req.status

        if req.status == 200
            server_resp = JSON.parse(req.body)
            puts server_resp["id"]
            puts server_resp["url"]
            byebug
            redirect_to server_resp["url"]
        else
            puts "ERROR WALAO"
            puts req.body
        end

        # puts resp.headers
        
    end

    def payment_response
    end

end

# Faraday.post 'http://myhost.local/my_url', {}, authorization: 

