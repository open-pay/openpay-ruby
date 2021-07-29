class OpenpayCountrys < ActiveRecord::Base
  enum country: [:MEX, :COL]
end
