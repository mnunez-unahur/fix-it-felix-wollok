import wollok.game.*
import animacion.*
import Elementos.*
import personaje.*


object felix inherits PersonajeAnimado(animacion=new Animacion(
				  										velocidad=0,
  														fotogramas=["felix/derecha-parado.png"]
  														), 
  									  position=new Position(x = 30, y = 2),
  								      velocidad = 30 ){
	
	var mirandoAlaDerecha = true
	var saltando = false

	
	
	const  animacionParado = new Animacion( 
				  						velocidad=0,
  										fotogramas=["felix/derecha-1.png"]
  								)
  
  
	const  animacionReparandoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=6,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png", 
  													"felix/derecha-golpeando.png"]
  								)
    const  animacionReparandoIzquierda = new Animacion( 
				  						velocidad=6,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png", 
  													"felix/izquierda-golpeando.png"]
  								)  

	const  animacionSaltandoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png", 
  													"felix/izquierda-saltando-2.png"
  													]
  								)
  	const  animacionSaltandoDerecha = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png", 
  													"felix/derecha-saltando-2.png"
  													]
  								)

  	const  animacionCayendoDerecha = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/derecha-saltando-2.png",
  													"felix/derecha-saltando-1.png",
  													"felix/derecha-parado.png"
  													]
  								)

  	const  animacionCayendoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-saltando-2.png",
  													"felix/izquierda-saltando-1.png",
  													"felix/izquierda-parado.png"
  													]
  								)

  								
  	method reparar(ventana){
  		self.detenerMovimiento()
		self.animar(self.animacionReparando())
		game.schedule(500,{
			ventana.reparar()
			self.resetearAnimacion()
		})	
  	}
  	
  	method animacionReparando() {
  		return if(mirandoAlaDerecha) animacionReparandoDerecha else animacionReparandoIzquierda
  	}
  	
  	method animacionSaltando() {
  		return if(mirandoAlaDerecha) animacionSaltandoDerecha else animacionSaltandoIzquierda
  	}
  	method animacionCayendo() {
  		return if(mirandoAlaDerecha) animacionCayendoDerecha else animacionCayendoIzquierda
  	}

  	
  	method moverA(x,y){
  		if(!saltando) {
	  		mirandoAlaDerecha = x >= self.coordenadaActualX()
	  		saltando = true
			self.animar(self.animacionSaltando())
	  		self.moverAPosicionyHacerAccion(x,y, {
	  			self.animar(self.animacionCayendo())
	  			saltando = false
	  		})  			
  		}
  		
  	}
}
