class AddColumnToCoupon < ActiveRecord::Migration
  def change
    add_column :coupons, :status, :boolean
  end
end
