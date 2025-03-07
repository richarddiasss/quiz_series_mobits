class SeriesController < InheritedResources::Base
  before_action :authorize

  def question    
    results = QuestionService.call
    render json: results

  end

  def answer_question
    id_character, id_serie = params.dig(:personagem, :id), params.dig(:serie, :id)
    results = AnswerService.new(id_character, id_serie, @user).analyze_answer
    render json: results
    
  end

  private

  def serie_params
    params.require(:serie).permit(:id_serie, :name_pt, :original_name, :country, :popularity, :average_voting, :synopsis, :url_photo)
  end

end
