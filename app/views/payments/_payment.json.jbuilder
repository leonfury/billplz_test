json.extract! payment, :id, :payment_status, :details, :created_at, :updated_at
json.url payment_url(payment, format: :json)
