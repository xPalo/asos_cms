class ChangeColumnNullOnMessagesSubject < ActiveRecord::Migration[7.0]
  def change
    change_column_null :messages, :subject, true
  end
end
