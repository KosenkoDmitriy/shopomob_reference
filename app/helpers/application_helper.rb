module ApplicationHelper
  def example(options={}, &block)
    out = render :partial => 'home/header', :locals => {:options => options}
    out << capture(&block)
    #out << (render :partial => 'home/footer', :locals => {:options => options})
    out
  end

  def shops
    @shops = Shop.all[0..4]
    proc do |primary|
      @shops.each do |shop|
        primary.item "../shops/#{shop.id}", shop.name, "../shops/#{shop.id}" do |sub_nav|
          #sub_nav.item :shop_1, "Shop1", "1"
        end
      end
    end
  end

  def cats
    @items = Category.all
    proc do |primary|
      @items.each do |item|
        primary.item "../cats/#{item.id}", item.name, "../cats/#{item.id}" do |sub_nav|
          #sub_nav.item :shop_1, "Shop1", "1"
        end
      end
    end
  end

  def tcats
    @items = CategoryItem.where(parent_id:0)
    proc do |primary|
      @items.each do |item|
        primary.item :tcats, item.name, "../tcats/#{item.id}" do |sub_nav|

            #sub_nav.item "tcats_#{item.id}", item.name, "../tcats/#{item.id}"
          end
      end
    end
  end


end
