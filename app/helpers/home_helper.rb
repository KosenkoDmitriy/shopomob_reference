module HomeHelper
  def format_phone(phone, is_home)
    phone = phone.gsub('+','')
    if (is_home) #home phone
         contry_code = 7
         code = phone.at(0..3)
         group1 = phone.at(4..5)
         group2 = phone.at(6..7)
         group3 = phone.at(8..9)
    else

      if (phone.size==10) #mobile phone without country code
        contry_code = 7 #phone.at(0..2)
        code = phone.at(0..2)
        group1 = phone.at(3..5)
        group2 = phone.at(6..7)
        group3 = phone.at(8..9)
      elsif (phone.size==11) #mobile phone with country code
        contry_code = 7 # phone.first(1)
        code = phone.at(1..3)
        group1 = phone.at(4..6)
        group2 = phone.at(7..8)
        group3 = phone.at(9..11)

      end
    end
    phone = "+#{contry_code} (#{code}) #{group1} #{group2} #{group3}"

    return phone

    #return phone if format.blank?
    #groupings = format.scan(/d+/).map { |g| g.length }
    #groupings = [3, 3, 4] unless groupings.length == 3
    #ActionController::Base.helpers.number_to_phone(
    #    phone,
    #    :area_code => format.index('(') ? true : false,
    #    :groupings => groupings,
    #    :delimiter => format.reverse.match(/[^d]/).to_s
    #)
  end
end
