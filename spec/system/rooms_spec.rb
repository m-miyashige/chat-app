require 'rails_helper'

RSpec.describe "チャットルームの削除機能", type: :system do
  before do
    @room_user = FactoryBot.create(:room_user)
  end

  it 'チャットルームを削除すると、関連するメッセージがすべて削除されている' do
    # サインインする
    sign_in(@room_user.user)

    # 作成されたチャットルームへ遷移する
    click_on(@room_user.room.name)

    # メッセージ情報を5つDBに追加する
    # posts = ["post1", "post2", "post3", "post4", "post5"]
    # posts.each do |post|
    #   fill_in 'message_content', with: post
    #   expect{
    #     click_on('送信')
    #     sleep 1
    #   }.to change {Message.count}.by(1)
    # end
    FactoryBot.create_list(:message, 5, room_id: @room_user.room.id, user_id: @room_user.user.id)


    # 『チャットを終了する』ボタンをクリックすることで、作成した5つのメッセージが削除されていることを確認する
    # expect{
    #   click_on('チャットを終了する')
    #   sleep 1
    # }.to change { Message.count }.by(-5)
    expect{
      find_link('チャットを終了する',  href: room_path(@room_user.room)).click
      sleep 1
    }.to change { @room_user.room.messages.count }.by(-5)
    
    # トップページに遷移していることを確認する
    expect(current_path).to eq(root_path)
  end


end
