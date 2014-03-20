class CreateFreights < ActiveRecord::Migration
  def change
    create_table :freights do |t|
      t.string :consignee
      t.string :status
      t.text :remark
      t.timestamps
    end
  end
end
