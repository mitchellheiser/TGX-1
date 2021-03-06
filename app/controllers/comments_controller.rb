class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end
  
  # GET /comments/1
  # GET /comments/1.json
  def show
  end
  
  # GET /comments/new
  def new
    @comment = Comment.new
  end
  
  # GET /comments/1/edit
  def edit
    check_permissions
    
    
  end
  
  # POST /comments
  # POST /comments.json
  def create
    # render json: comment_params
    # post = Post.find(params[:comment][:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.flagged = false
    # @comment.save
    # redirect_to post_path(@comment.post_id)
    
    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@comment.post_id), notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_path(@comment.post_id), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @post_id = @comment.post_id
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to post_path(@post_id), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:content, :flagged, :post_id, :user_id)
  end
  def check_permissions
    if !@comment.can_change?(current_user)
      redirect_to(request.referrer || root_path, :alert => "You are not authorized to perform that action!")
    end
  end
end
