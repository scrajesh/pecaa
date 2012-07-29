class Product < ActiveRecord::Base
  has_many :product_images
  has_many :product_videos
  has_many :product_options
  has_many :categories
  has_many :vendors
  has_many :inventories
  has_many :related_products
  has_one  :rel_product, :class_name => 'RelatedProduct'
  
  belongs_to :site
  belongs_to :product_categories
  
  has_many :order_products
  has_many :orders, :through => :order_products
  

  attr_accessor :price
  
  liquid_methods :id, :name, :sku, :vendor, :sold, :viewed, :rating, :is_active, :created_at, :updated_at, :base_price, :actual_img_path,
  :retail_price, :cost, :weight, :shipping_modifier, :case_price, :description, :image_path, :last_vendor_name, :price, :active_product_options
 
  
  def image_path
    image = self.product_images.where(:is_thumbnail => true)
    image = self.product_images.first if image.empty?
    image_path = image ? image.image_path : '/assets/productimg.jpg'
    "<img src='#{image_path}' alt='image'>"
  end
  
  
  def actual_img_path
    image = self.product_images.where(:is_thumbnail => true)
    image = self.product_images.first if image.empty?
    raise image.url(:medium).inspect
    image_path = image ? image.url(:medium) : '/assets/productimg.jpg'
    "<img src='#{image_path}' alt='image'>"
  end
  

  def last_vendor_name
    vendors.last.try(:name)
  end
  
  def self.featured_products
    Product.where(:is_featured => true)
  end

  def price_with_quantity(quantity)
    (base_price * quantity.to_i).to_f
  end

  def active_product_options
    product_options.only_active
  end
  
end