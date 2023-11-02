class PostsController < ApplicationController
    before_action :authenticate_user!
    def index
        @posts = Post.all
        @posts = Post.all.order(created_at: :desc)

        if params[:latest]
            @posts = Post.latest
        elsif params[:old]
            @posts = Post.old
        elsif params[:most_favorited]
            @posts = Post.most_favorited
        else
            @posts = Post.all
        end

        if params[:tag]
            Tag.create(name: params[:tag])
        end

        @tags = Tag.all
        @posts = Post.where("name LIKE ? OR graduation LIKE ? OR title LIKE ? OR date LIKE ? OR about LIKE ? OR username LIKE ? OR overall LIKE ? OR level LIKE ?", '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%', '%' + params[:search] + '%') if params[:search].present?
        #もしタグ検索したら、post_idsにタグを持ったidをまとめてそのidで検索
        if params[:tag_ids].present?
            post_ids = []
            params[:tag_ids].each do |key, value| 
            if value == "1"
                Tag.find_by(name: key).posts.each do |p| 
                    post_ids << p.id
                end
            end
        end
            post_ids = post_ids.uniq
            #キーワードとタグのAND検索
            @posts = @posts.where(id: post_ids) if post_ids.present?
        end

        @tag = Tag.select("name", "id")
        tag_search = params[:tag_search]
        if tag_search != nil
            @posts = Tag.find_by(id: tag_search).posts
        end

        @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(5)
    end

    def new
        @post = Post.new
    end

    def create
        post = Post.new(post_params)
        post.user_id = current_user.id
        if post.save
            redirect_to :action => "index" 
        else
            redirect_to :action => "new"
        end
    end

    def show
        @post = Post.find(params[:id])
        
        @comments = @post.comments
        @comment = Comment.new 
    end

    def edit
        @post = Post.find(params[:id])
    end

    def update
        post = Post.find(params[:id])
        if post.update(post_params)
            redirect_to :action => "show", :id => post.id
        else
            redirect_to :action => "new"
        end
    end

    def destroy
        post = Post.find(params[:id])
        post.destroy
        redirect_to action: :index
    end

    private
    
    def post_params
        params.require(:post).permit(:name, :graduation, :title, :date, :about, :username, :overall, :level, tag_ids: [])
    end
end