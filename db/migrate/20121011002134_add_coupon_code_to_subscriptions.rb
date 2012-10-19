class AddCouponCodeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :coupon_code, :text
  end
end
