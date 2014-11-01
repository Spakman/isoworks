module Paginatable
  PER_PAGE = 60

  def number_of_pages
    (size / PER_PAGE.to_f).ceil
  end

  def items_for_page(page)
    first_item = (page - 1) * PER_PAGE
    slice(first_item, PER_PAGE)
  end

  def size
    super
  rescue NoMethodError
    fail NotImplementedError, "objects must respond to #size to be Paginatable."
  end

  def slice(start, length)
    super
  rescue NoMethodError
    fail NotImplementedError, "objects must respond to #slice to be Paginatable."
  end
end
