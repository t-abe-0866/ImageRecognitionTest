class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy ]
  before_action :require_user_logged_in

  # GET /images or /images.json
  def index
    @images = Image.all
  end

  # GET /images/1 or /images/1.json
  def show
    @result = Image.find(params[:id]).result
    @result_x = Image.find(params[:id]).pos_xp1.to_i
    @result_y = Image.find(params[:id]).pos_yp1.to_i
    @result_xl = Image.find(params[:id]).pos_xl1.to_i
    @result_yl = Image.find(params[:id]).pos_yl1.to_i

  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images or /images.json
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      if @image.save
        if @image.status == 1
          result = CharacterRecognition(@image.id)
        elsif @image.status == 2
          result = FaceRecognition(@image.id)
        else
          result = LabelRecognition(@image.id)
        end

        @image.result = result[0]
        @image.pos_xp1 = result[1]
        @image.pos_yp1 = result[2]
        @image.pos_xl1 = result[3] - result[1]
        @image.pos_yl1 = result[8] - result[2]

        if @image.save
          format.html { redirect_to image_url(@image), notice: "テストが正常に作成されました。" }
          format.json { render :show, status: :created, location: @image }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end

    end
  end

  # PATCH/PUT /images/1 or /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)

        if @image.status == 1
          result = CharacterRecognition(@image.id)
        elsif @image.status == 2
          result = FaceRecognition(@image.id)
        else
          result = LabelRecognition(@image.id)
        end
        
        @image.result = result[0]
        @image.pos_xp1 = result[1]
        @image.pos_yp1 = result[2]
        @image.pos_xl1 = result[3] - result[1]
        @image.pos_yl1 = result[8] - result[2]

        if @image.save
          format.html { redirect_to image_url(@image), notice: "テストが正常に更新されました。" }
          format.json { render :show, status: :ok, location: @image }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end

        format.html { redirect_to image_url(@image), notice: "テストが正常に更新されました。" }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url, notice: "画像は正常に破棄されました。" }
      format.json { head :no_content }
    end
  end

  private
    # 文字を検出する params[:id]
    def CharacterRecognition(num_id)
      # ②APIキーを定義
      api_key = "AIzaSyB0W6fO4EMGDjY3yh0HzMrKoRK3hXnF5-s"
      # ③リクエストURLを定義
      api_url = URI("https://vision.googleapis.com/v1/images:annotate?key=#{api_key}")
      base64_image = Base64.strict_encode64(File.open("./public" + Image.find(num_id).avatar.url).read)#params[:avatar]
  
      @url = "./public" + Image.find(num_id).avatar.url
  
      # ④リクエストボディを定義
      body = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'DOCUMENT_TEXT_DETECTION',
              maxResults: 6
            }
          ]
        }]
      }.to_json
      # ⑤リクエストヘッダーを定義
      headers = { "Content-Type" => "application/json" }
      # ①リクエストを送信し、返ってきたレスポンスを変数responseに格納
      response = Net::HTTP.post(api_url, body, headers)
      text = JSON.parse(response.body)
  
      @result = ["",0,0,0,0,0,0,0,0]
  
      for var in text["responses"][0]["textAnnotations"] do
        @result[0] = @result[0] + var["description"] + ","
      end

      @result[0] = @result[0] + "etc."
      return @result
    end

    # ラベルを検出する params[:id]
    def LabelRecognition(num_id)
      # ②APIキーを定義
      api_key = "AIzaSyB0W6fO4EMGDjY3yh0HzMrKoRK3hXnF5-s"
      # ③リクエストURLを定義
      api_url = URI("https://vision.googleapis.com/v1/images:annotate?key=#{api_key}")
      base64_image = Base64.strict_encode64(File.open("./public" + Image.find(num_id).avatar.url).read)#params[:avatar]
  
      @url = "./public" + Image.find(num_id).avatar.url
  
      # ④リクエストボディを定義
      body = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'LABEL_DETECTION',
              maxResults: 6
            }
          ]
        }]
      }.to_json
      # ⑤リクエストヘッダーを定義
      headers = { "Content-Type" => "application/json" }
      # ①リクエストを送信し、返ってきたレスポンスを変数responseに格納
      response = Net::HTTP.post(api_url, body, headers)
      text = JSON.parse(response.body)
  
      @result = ["",0,0,0,0,0,0,0,0]
  
      for var in text["responses"][0]["labelAnnotations"] do
        @result[0] = @result[0] + var["description"] + ","
      end

      @result[0] = @result[0] + "etc."
      return @result
    end

    # 顔を検出する params[:id]
    def FaceRecognition(num_id)
      # ②APIキーを定義
      api_key = "AIzaSyB0W6fO4EMGDjY3yh0HzMrKoRK3hXnF5-s"
      # ③リクエストURLを定義
      api_url = URI("https://vision.googleapis.com/v1/images:annotate?key=#{api_key}")
      base64_image = Base64.strict_encode64(File.open("./public" + Image.find(num_id).avatar.url).read)#params[:avatar]
  
      @url = "./public" + Image.find(num_id).avatar.url
  
      # ④リクエストボディを定義
      body = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'FACE_DETECTION',
              maxResults: 1
            }
          ]
        }]
      }.to_json
      # ⑤リクエストヘッダーを定義
      headers = { "Content-Type" => "application/json" }
      # ①リクエストを送信し、返ってきたレスポンスを変数responseに格納
      response = Net::HTTP.post(api_url, body, headers)
      text = JSON.parse(response.body)
  
      @result = ["",0,0,0,0,0,0,0,0]

      i = 0
  
      for var in text["responses"][0]["faceAnnotations"][0]["boundingPoly"]["vertices"] do
        j = i * 2
        @result[j + 1] = var["x"]
        @result[j + 2] = var["y"]
        i = i + 1
      end
      return @result
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def image_params
      params.require(:image).permit(:avatar,:status,:result,:title,:suggestion) 
    end
end
