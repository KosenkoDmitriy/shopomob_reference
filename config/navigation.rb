# -*- coding: utf-8 -*-
# Configures your navigation
require 'unicode'
#require 'unicode_utils'
#require "unicode_utils/upcase"
SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = SimpleNavigationRenderers::Bootstrap2

  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items.
  # Defaults to 'selected' navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  # navigation.id_generator = Proc.new {|key| "my-prefix-#{key}"}

  # If you need to add custom html around item names, you can define a proc that
  # will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name, item| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false
  
  # If this option is set to true, all item names will be considered as safe (passed through html_safe). Defaults to false.
  # navigation.consider_item_names_as_safe = false

  # Define the primary navigation

  #navigation.renderer = SimpleNavigationRenderers::Bootstrap3
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav' #for simple-navigation-boostrap gem



    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>if: -> { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>unless: -> { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #
    #primary.item :key_1, 'name', url, options
    #
    ## Add an item which has a sub navigation (same params, but with block)
    #primary.item :key_2, 'name', url, options do |sub_nav|
    #  # Add an item to the sub navigation (same params again)
    #  sub_nav.item :key_2_1, 'name', url, options
    #end
    #
    ## You can also specify a condition-proc that needs to be fullfilled to display an item.
    ## Conditions are part of the options. They are evaluated in the context of the views,
    ## thus you can use all the methods and vars you have available in the views.
    #primary.item :key_3, 'Admin', url, class: 'special', if: -> { current_user.admin? }
    #primary.item :key_4, 'Account', url, unless: -> { logged_in? }
    #
    ## you can also specify html attributes to attach to this particular level
    ## works for all levels of the menu
    ## primary.dom_attributes = {id: 'menu-id', class: 'menu-class'}
    #
    ## You can turn off auto highlighting for a specific level
    ## primary.auto_highlight = false


    #primary.item :header_admin, 'Admin', 'admin#', :opts => {:nav_header => true}
    #primary.item :my_items, 'My Items', "items#", :opts => {:icon => 'icon-th'} do |sub_nav|
    #  sub_nav.item "item_1", "Item 1", "items/1", :opts => {:is_subnavigation => true}
    #
    #end
    #primary.item "item_2", "Item 2", "items/2", :opts => {:is_subnavigation => true}




    #primary.dom_id = 'cats'
    #primary.dom_class = 'nav navbar-nav'
    #primary.item :home, 'Главная', root_path
    #
    #
    #items = ['Аа','Бб', 'Вв', 'Гг', 'Дд', 'Ее', 'Жж', 'Зз', 'Ии', 'Кк', 'Лл', 'Мм', 'Нн', 'Оо', 'Пп', 'Рр', 'Сс', 'Тт', 'Уу', 'Фф', 'Хх', 'Цц', 'Чч', 'Шш', 'Щщ', 'Ыы', 'Ээ', 'Юю', 'Яя',
    #'Aa', 'Bb', 'Cc', 'Dd', 'Ee', 'Ff', 'Gg', 'Hh', 'Ii', 'Jj', 'Kk', 'Ll', 'Mm', 'Nn', 'Oo', 'Pp', 'Qq', 'Rr', 'Ss', 'Tt', 'Uu', 'Vv', 'Ww', 'Xx', 'Yy', 'Zz']
    #i=0
    #primary.item :shops, 'Компании', shops_path do |sub_nav|
    #  items.each do |item|
    #    query=item[1]
    #    sub_nav.item "shop_#{i}", item, "#{shops_path}?query=#{query}" do |shop_nav|
    #    i+=1
    #    Shop.where("name like '#{Unicode::upcase(query)}%' or name like '#{Unicode::downcase(query)}%'").order(favorite: :desc, rated: :desc, name: :asc).each do |shop|
    #       #{shops_path}?query=#{item[1]}"
    #        shop_nav.item "shop_detail_#{shop.id}", shop.name, "#{shops_path}/#{shop.id}" do |shop_detail_nav|
    #        end
    #      end
    #    end
    #  end
    #end
    #
    #primary.item :tcats, 'Рубрики', tcats_path do |sub_nav|
    #  CategoryItem.where(parent_id:0).order(name: :asc).each do |item|
    #    sub_nav.item "tcats_#{item.id}", item.name, tcats_path+"/"+item.id.to_s do |sub_nav2|
    #      CategoryItem.where(parent_id:item.id).order(name: :asc).each do |item2|
    #        sub_nav2.item "tcats2_#{item2.id}", item2.name, tcats_path+"/"+item2.id.to_s do |shop_nav|
    #          CategoryItem.find(item2.id).shops.order(favorite: :desc, rated: :desc, name: :asc).each do |shop|
    #            shop_nav.item "tcat_shops_#{shop.id}", shop.name, "#{tcats_path}/#{item2.id}?shop_id=#{shop.id}" do |shop_detail_nav|
    #              shop_detail = Shop.find(shop.id)
    #              shop_detail_nav.item "shop_#{shop_detail.id}", shop_detail.name, "#{shops_path}/#{shop_detail.id}"
    #            end
    #          end
    #      end
    #      end
    #    end
    #  end
    #end
    #
    #primary.item :cats, 'Категории', cats_path do |sub_nav|
    #  Category.all.order(name: :asc).each do |item|
    #    #sub_nav.dom_id = 'cats'
    #    #sub_nav.dom_class = 'nav nav-pills nav-stacked list-icon'
    #    sub_nav.item "cats_#{item.id}", item.name, cats_path+"/"+item.id.to_s do |shop_nav|
    #      Category.find(item.id).shops.order(favorite: :desc, rated: :desc, name: :asc).each do |shop|
    #        shop_nav.item "cat_shops_#{shop.id}", shop.name, "#{cats_path}/#{item.id}?shop_id=#{shop.id}" do |shop_detail_nav|
    #          shop_detail = Shop.find(shop.id)
    #          shop_detail_nav.item "shop_#{shop_detail.id}", shop_detail.name, "#{shops_path}/#{shop_detail.id}"
    #        end
    #      end
    #    end
    #  end
    #end
    #
    ##primary.item :contacts, 'Контакты', contacts_path
    #
    #primary.item :services, 'Услуги', services_path do |sub_nav|
    #  #sub_nav.dom_id = ''
    #  #sub_nav.dom_class = 'dropdown-menu'
    #  sub_nav.item :service_1, 'Реклама в справочнике Владикавказа', services_adv_path
    #  sub_nav.item :service_2, 'Аренда мобильного приложения', services_rent_app_path
    #  sub_nav.item :service_3, 'Аренда интернет-магазина', services_rent_shop_path
    #  sub_nav.item :service_4, 'СМС-рассылка', services_sms_path
    #end

    #primary.item :home, 'Главная', root_path

    primary.item :shops, 'Компании', shops_path
    #do |sub_nav|
    #  items = ['А','Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З', 'И', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ы', 'Э', 'Ю', 'Я',
    #           'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
    #  i=0
    #  items.each do |item|
    #    #sub_nav.dom_class="nav nav-pills"#nav nav-tabs"
    #    sub_nav.dom_class="nav nav-tabs"
    #    #sub_nav.item "item_#{i}", item, search_shop_path(item)
    #    #sub_nav.item "item_#{i}", item, "#{shops_path}/#{Shop.first.id}/?query=#{item}"
    #    sub_nav.item "item_#{i}", item, "#{shops_path}/1/?query=#{item}" do |sub_item|
    #      #sub_item.dom_class="nav nav-tabs"
    #      #sub_item.item "sitem_#{i}", item, "#{shops_path}/1/?query=#{item}"
    #
    #    end
    #  end
    #end

    primary.item :tcats, I18n.t('cats'), tcats_path
    #primary.item :cats, I18n.t('tcats'), cats_path #do |sub_nav|
    primary.item :services, I18n.t('services'), services_path
  end
end
