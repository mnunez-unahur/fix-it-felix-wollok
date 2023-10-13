import wollok.game.*
import animacion.*
import Elementos.*
import personaje.*


object felix inherits PersonajeAnimado(animacion=new Animacion(
				  										velocidad=0,
  														fotogramas=["felix/derecha-1.png"]
  														), 
  									  position=new Position(x = 30, y = 2),
  								      velocidad = 20 ){
	
	var mirandoAlaDerecha = true
	
	
	const  animacionParado = new Animacion( 
				  						velocidad=0,
  										fotogramas=["felix/derecha-1.png"]
  								)
  
  
	const  animacionReparandoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=6,
  										fotogramas=["felix/derecha-1.png","felix/derecha-2.png", "felix/derecha-3.png"]
  								)
    const  animacionReparandoIzquierda = new Animacion( 
				  						velocidad=6,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-1.png","felix/izquierda-2.png", "felix/izquierda-3.png"]
  								)  

	const  animacionSaltandoIzquierda = new Animacion( 
				  						velocidad=5,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-1.png", "felix/derecha-2.png"]
  								)
  	const  animacionSaltandoDerecha = new Animacion( 
				  						velocidad=5,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-1.png", "felix/derecha-2.png"]
  								)
  								
  	method reparar(ventana){
  		self.detenerMovimiento()
		self.animar(self.animacionReparando())
		game.schedule(500,{ventana.reparar()})	
  	}
  	
  	method animacionReparando() {
  		return if(mirandoAlaDerecha) animacionReparandoDerecha else animacionReparandoIzquierda
  	}
  	method animacionSaltando() {
  		return if(mirandoAlaDerecha) animacionSaltandoDerecha else animacionSaltandoIzquierda
  	}
  	method moverA(x,y){
  		self.resetearAnimacion()
  		animacion = self.animacionSaltando()
  		self.siguienteFotograma()
  		self.moverAPosicionyHacerAccion(x,y, {(self.resetearAnimacion())})
  		
  	}
}
