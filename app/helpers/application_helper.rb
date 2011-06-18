module ApplicationHelper
  # Definicion del metodo de titulo base para las paginas
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  #carga de logo en la pagina
  def logo
     logo = image_tag("logo.png", :alt => "Sample App", :class => "round")
  end
end
