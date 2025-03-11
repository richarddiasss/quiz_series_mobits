class AnswerService

  def initialize(id_character, id_serie, user)
    @id_character = id_character
    @id_serie = id_serie
    @user = user
    @player_answer = nil
  end 

  def analyze_answer
    @character = Character.find_by(id:@id_character)
    return {mensagem: "esse personagem não existe!"} if !@character

    if @id_serie.to_i == @character.serie_id
      puts "entrou"
      @player_answer = true
      return alter_user(@player_answer)
    end

    @player_answer = false
    alter_user(@player_answer)
    
  end


  def alter_user(player_answer)
    if player_answer
      @user.update(questions: @user.questions + 1, hits: @user.hits + 1)
      return {mensagem: "Parabéns! Você acertou!", status: 200}
    end

    @user.update(questions: @user.questions + 1)
    @serie = Serie.find_by(id:@character.serie_id)
    return {mensagem: "Não foi dessa vez... a resposta correta era: #{@serie.original_name}", status: 422}

  end

end