class Post < ApplicationRecord
    belongs_to :user
    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user

    has_many :comments, dependent: :destroy

    scope :latest, -> { order(created_at: :desc) }  #desc = 降順
    scope :old, -> { order(created_at: :asc) }  #asc = 昇順
    scope :most_favorited, -> { includes(:liked_users)
        .sort_by { |x| x.liked_users.includes(:likes).size }.reverse }

    #tweetsテーブルから中間テーブルに対する関連付け
    has_many :post_tag_relations, dependent: :destroy
    #tweetsテーブルから中間テーブルを介してTagsテーブルへの関連付け
    has_many :tags, through: :post_tag_relations, dependent: :destroy

end
