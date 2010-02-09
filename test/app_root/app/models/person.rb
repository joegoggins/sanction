class Person < ActiveRecord::Base
  def the_true_check?(*args)
    true
  end
  def the_false_check?(*args)
    false
  end
end
