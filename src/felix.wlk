import wollok.game.*
import animacion.*
import Elementos.*
import personaje.*


object felix inherits PersonajeAnimado(animacion=new Animacion(
				  										velocidad=0,
  														fotogramas=["felix/derecha-parado.png"]
  														), 
  									  position=new Position(x = 30, y = 2),
  								      velocidad = 40 ){
	
	var mirandoAlaDerecha = true
	var saltando = false
	var perdiendoVida = false
	const sensores = []

	const  animacionParado = new Animacion( 
				  						velocidad=0,
  										fotogramas=["felix/derecha-1.png"]
  								)
  
  
	const  animacionReparandoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=6,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png", 
  													"felix/derecha-golpeando.png",
  													"felix/derecha-parado.png"]
  								)
    const  animacionReparandoIzquierda = new Animacion( 
				  						velocidad=6,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png", 
  													"felix/izquierda-golpeando.png",
  													"felix/izquierda-parado.png"]
  								)  

	const  animacionSaltandoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/izquierda-parado.png",
  													"felix/izquierda-saltando-1.png" 
//  													"felix/izquierda-saltando-2.png"
  													]
  								)
  	const  animacionSaltandoDerecha = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png" 
//  													"felix/derecha-saltando-2.png"
  													]
  								)

  	const  animacionCayendoDerecha = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=[
//  													"felix/derecha-saltando-2.png",
  													"felix/derecha-saltando-1.png",
  													"felix/derecha-parado.png"
  													]
  								)

  	const  animacionCayendoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=[
//													"felix/izquierda-saltando-2.png",
  													"felix/izquierda-saltando-1.png",
  													"felix/izquierda-parado.png"
  													]
  								)

	method initialize() {
		sensores.add(new Sensor(position = self.position()))
		sensores.add(new Sensor(position = self.position()))
		sensores.add(new Sensor(position = self.position()))
		self.actualizarSensores()
		
	}


	method saltando() = saltando
  								
  	method reparar(ventana){
  		if(!saltando) {
	  		self.detenerMovimiento()
			self.animar(self.animacionReparando())
			game.schedule(200,{
				ventana.reparar()
				self.siguienteFotograma()
			})	  			
  		}
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
  	
  	override method mostrar() {
  		super()
		game.whenCollideDo(self, { c => if(c.haceDanio()) self.perderVida()  }) 
		self.mostrarSensores()
		self.activarSensores()
  	}
  	
  	override method ocultar() {
  		super()
  		self.ocultarSensores()
  	}
  	
  	method mostrarSensores() {
		sensores.forEach({s => s.mostrar()})
  	}
  	method activarSensores() {
		sensores.forEach({s => game.whenCollideDo(s, { c => if(c.haceDanio()) self.perderVida()  })})
  	}
  	
  	method ocultarSensores() {
		sensores.forEach({s => s.ocultar()})  		
  	}
  	
  	method perderVida() {
  		if(!perdiendoVida) {
	  		perdiendoVida = true
	  		vida.perderVida()
	  		// por un segundo no pierde mas vida
	  		// TODO: agregar animacion
	  		game.schedule(1000, {
		  		perdiendoVida = false
	  		})
  		}
  	}

	method actualizarSensores() {
		var pos = self.position().up(2)
		sensores.forEach({s => s.position(pos); pos = pos.up(2)})
	}
  	
  	method moverA(x,y){
  		if(!saltando) {
  			self.ocultarSensores()
	  		mirandoAlaDerecha = x >= self.coordenadaActualX()
	  		saltando = true
			self.animar(self.animacionSaltando())
	  		self.moverAPosicionyHacerAccion(x,y, {
	  			self.actualizarSensores()
	  			self.mostrarSensores()
	  			self.animar(self.animacionCayendo())	  			
	  			saltando = false
	  		})  			
  		}
  	}
  	
  	override method detenerMovimiento() {
  		super()
  		saltando = false
  	}
  	
  	method reset() {
		self.resetearAnimacion()
		self.detenerMovimiento()
  		self.ocultarSensores()
		mirandoAlaDerecha = true
		perdiendoVida = false  		
  	}
}
