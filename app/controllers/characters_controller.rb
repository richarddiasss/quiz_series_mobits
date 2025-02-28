class CharactersController < InheritedResources::Base

  private

    def character_params
      params.require(:character).permit(:actor_name, :character_name, :url_photo, :serie_id)
    end

end
