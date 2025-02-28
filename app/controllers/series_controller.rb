class SeriesController < InheritedResources::Base
  before_action :authorize

  def question
    @series = Serie.all
    choose_series = []
    while choose_series.count < 4
      choose_serie = @series.sample

      unless choose_series.include?(choose_serie)
        choose_series << choose_serie
      end
    end
    
    @characters = []
    while @characters.count == 0 do
      serie_person = choose_series.sample
      @characters = Character.where(serie_id: serie_person.id)
    end

    choose_characters = @characters.sample

    render json: {
  personagem: {
    id: choose_characters.id,
    nome: choose_characters.character_name
  },
  series: choose_series.map { |serie| 
    { id: serie.id, nome: serie.name_pt, nome_original: serie.original_name }
  }
}

  end

  def answer_question

    id_character, id_serie = params.dig(:personagem, :id), params.dig(:serie, :id)

    @Character = Character.find_by(id:id_character)

    if id_serie == @Character.serie_id
      @user.update(questions: questions + 1, hits: hits + 1)
      return render json: {messagem: "Parabéns! Você acertou!"}
    end
    
    @user.update(questions: questions + 1)
    @serie = Serie.find_by(id:@Character.serie_id)
    render json: {messagem: "Não foi dessa vez... a resposta correta era: #{@serie.original_name}"}
  end

  private

    def serie_params
      params.require(:serie).permit(:id_serie, :name_pt, :original_name, :country, :popularity, :average_voting, :synopsis, :url_photo)
    end

end
