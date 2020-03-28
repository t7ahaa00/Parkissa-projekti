CV_environment.yml sisältää kaikki kirjastot joita tarvitsee scriptien ajamiseen.

Ympäristön tekoon tarvitsee Anaconda python pakettien hallinta-alustan, jonka saa osoitteesta https://www.anaconda.com/distribution/

1.Asennuksen jälkeen avaa anaconda prompt
2.Navigoi komentorivillä siihen kansioon missä CV_environment.yml sijaitsee
3.Kirjoita: conda env create -f CV_environment.yml
4.Aktivoi ympäristö: conda activate opencv-env
5.Nyt voit kokeilla scriptien toimintaa