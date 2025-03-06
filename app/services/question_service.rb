class QuestionService

  def self.call
    
    @series = Serie.all

    choose_series = []
    while choose_series.count < 4
      choose_serie = @series.sample

      unless choose_series.include?(choose_serie)
        choose_series << choose_serie
      end

    end
    character = get_character(choose_series)

    sucess_question( character, choose_series)
    
  end

  private

  def self.get_character(series)
    @characters = []
    puts "bom dia"
    puts series[0]
    while @characters.count == 0 do
      serie_person = series.sample
      @characters = Character.where(serie_id: serie_person.id)
    end
    
    return @characters.sample
  end

  def self.sucess_question( character, series)
    {
      personagem: {
        id: character.id,
        nome: character.character_name
      },
      series: series.map { |serie| 
        { id: serie.id, nome: serie.name_pt, nome_original: serie.original_name }
      }, status: :ok
    }

  end

end
