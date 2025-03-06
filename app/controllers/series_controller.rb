class SeriesController < InheritedResources::Base
  before_action :authorize

  def question
    
    results = QuestionService.call
    puts results
    render json: {
      message: "ok"
    }

  end

  def answer_question

    id_character, id_serie = params.dig(:personagem, :id), params.dig(:serie, :id)

    @character = Character.find_by(id:id_character)
    return render json: {mensagem: "esse personagem não existe!"} if !@character
    if id_serie.to_i == @character.serie_id
      puts "entrou"
      @user.update(questions: @user.questions + 1, hits: @user.hits + 1)
      return render json: {mensagem: "Parabéns! Você acertou!"}
    end
    
    @user.update(questions: @user.questions + 1)
    @serie = Serie.find_by(id:@character.serie_id)
    render json: {mensagem: "Não foi dessa vez... a resposta correta era: #{@serie.original_name}"}
  end

  private

    def serie_params
      params.require(:serie).permit(:id_serie, :name_pt, :original_name, :country, :popularity, :average_voting, :synopsis, :url_photo)
    end

end
