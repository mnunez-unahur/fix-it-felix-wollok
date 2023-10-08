import animacion.*

class Ventana {
	var property position
	const  animacion = new Animacion(nombre = "ventana", 
				  						velocidad=0,
  										fotogramas=["ventana/1/rota-2.png", "ventana/1/rota-1.png", "ventana/1/sana.png"]
  								)	
	method image() = animacion.image()
	
}
