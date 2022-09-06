# Ecto에서 기본키 생성하기 금지 !
create table("compositions", primary_key: false) do
  add :title, :string, null: false
  #...
end
  # You could then add a primary key to the table manually when calling add:
  create table("compositions", primary_key: false) do
    add :code, :string, primary_key: true
    #...
  end

  # 외래키를 생성할때 원하는 키값으로 생성하게 할수있다.
  create table("compositions_artists") do
    add :composition_id, references("compositions",
    column: "code", type: "string")
    #...
    end
