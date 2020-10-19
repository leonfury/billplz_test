class Payment < ApplicationRecord
    validates :billplz_id, uniqueness: true, allow_blank: true
    enum payment_status: [:unknown, :success, :failure]
end
