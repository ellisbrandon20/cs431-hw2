module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def header_style(header_type)
    @sort == header_type ? "hilite" : ""
  end
end
