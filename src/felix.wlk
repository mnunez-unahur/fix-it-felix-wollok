import wollok.game.*
import animacion.*
import elementos.*
import personaje.*
import juego.*


object felix inherits Animado( position=new Position(x = 30, y = 2),
  							   velocidad = 40 ){
	
	var mirandoAlaDerecha = true
	var saltando = false
	var reparando = false
	
	//mientras felix está inmune los objetos no le hacen daño
	var inmune = false
	const sensores = []
	
	//referencia al stage actual
	var property stage = nullStage

	const  animacionParadoDerecha = new Animacion( 
										reproduccionContinua= false,
				  						velocidad=0,
  										fotogramas=["felix/derecha-parado.png"])
 
  
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
  													]
  								)
  	const  animacionSaltandoDerecha = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=["felix/derecha-parado.png",
  													"felix/derecha-saltando-1.png" 
  													]
  								)

  	const  animacionCayendoDerecha = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/derecha-saltando-1.png",
  													"felix/derecha-parado.png"
  													]
  								)

  	const  animacionCayendoIzquierda = new Animacion( 
				  						velocidad=10,
				  						reproduccionContinua= false,
  										fotogramas=[
  													"felix/izquierda-saltando-1.png",
  													"felix/izquierda-parado.png"
  													]
  								)

  	const  animacionPerdiendoVida = new Animacion( 
				  						velocidad=5,
				  						reproduccionContinua= true,
  										fotogramas=[
  													"felix/derecha-parado.png",
  													"nada.png",
  													"felix/derecha-parado.png"
  													]
  								)


	method initialize() {
		animacion = animacionParadoDerecha
		sensores.add(new Sensor(position = self.position()))
		sensores.add(new Sensor(position = self.position()))
		sensores.add(new Sensor(position = self.position()))
		sensores.add(new Sensor(position = self.position()))
		self.actualizarSensores()
		
	}


	method saltando() = saltando
	method reparando() = reparando
  								
  	method reparar(ventana){
  		if(!saltando && !reparando) {
  			reparando = true
	  		self.detenerMovimiento()
			self.animar(self.animacionReparando())
			game.schedule(200,{
				if(ventana.salud() < 2) {
					score.sumarPuntos(50)				
				}
				ventana.reparar()
				reparando = false
				self.siguienteFotograma()
			})	 
			arreglar.reproducir() 			
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
		sensores.forEach({s => s.activarDeteccion({ c => if(c.haceDanio()) self.perderVida()  })})
  	}
  	
  	method ocultarSensores() {
		sensores.forEach({s => s.ocultar()})  		
  	}
  	
  	override method position(pos) {
  		super(pos)
  		self.actualizarSensores()
  	}
  	
	method perderVida() {
  		if(!inmune) {
	  		inmune = true
	  		self.perderVida2()
			self.animar(animacionPerdiendoVida)
	  		game.schedule(3000, {
	  			inmune = false
				self.resetearAnimacion()		
	  		})
	  	
  	}}
  	
  	method perderVida2(){ // cuando se queda sin vidas finaliza el juego. CAMBIARLO A JUEGO
  		if(vida.vidasActuales()>1){
	  		vida.perderVida()
	  		restarVida.reproducir()
  		}else{
  			juego.stageActual().finalizar()
  			gameOver.mostrar()
  			sgameOver.reproducir()
  		}
  	}

	method actualizarSensores() {
		var pos = self.position().up(3)
		sensores.forEach({s => s.position(pos); pos = pos.up(3)})
	}
  	
  	override method moverAPosicionyHacerAccion(x,y, accion){
  		if(!saltando) {
	  		mirandoAlaDerecha = x >= self.coordenadaActualX()
	  		saltando = true
			self.animar(self.animacionSaltando())
	  		super(x,y, {
	  			self.actualizarSensores()
	  			self.animar(self.animacionCayendo())	  			
	  			saltando = false
	  			accion.apply()
	  		})  
	  	  	salto.reproducir()
  		}
  	}
  	
  	override method detenerMovimiento() {
  		super()
  		saltando = false
  	}
  	
  	method reset() {
		self.resetearAnimacion()
		self.detenerMovimiento()
		self.actualizarSensores()
		mirandoAlaDerecha = true
		inmune = false 
		reparando = false
  	}
}
