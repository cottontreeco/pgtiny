class Freight < ActiveRecord::Base
  EStatus = ['Initial', 'B/L Received', 'Finalized']
  EType = ['Ocean Import', 'Ocean Export', 'Air Import', 'Air Export']
  #attr_accessible :consignee, :status, :remark
end
