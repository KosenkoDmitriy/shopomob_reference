module ApplicationHelper
  def example(options={}, &block)
    out = render :partial => 'home/header', :locals => {:options => options}
    out << capture(&block)
    #out << (render :partial => 'examples/footer', :locals => {:options => options})
    out
  end
end
