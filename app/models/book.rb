class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user#favorited_usersは、favoritesテーブルを通って、userモデルのデータ持ってくるイメージ
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy#閲覧数カウント

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

#scope :スコープの名前, -> { 条件式 }
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }# Time.zone.now.all_day　1日を表す。
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }# 1.day.ago.all_day　前日を表す。
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }# １週間
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }# ２週間前

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

# 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"#・完全一致→perfect_match
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"#・前方一致→forward_match
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"#・後方一致→backword_match
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"#・部分一致→partial_match
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
