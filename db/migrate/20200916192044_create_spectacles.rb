class CreateSpectacles < ActiveRecord::Migration[6.0]
  def change
    create_table :spectacles do |t|
      t.string :name
      t.daterange :duration, index: { using: :gist }
    end
  end
end
