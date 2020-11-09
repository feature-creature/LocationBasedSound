// import minim library for sound
// you can get it by going to:
// sketch/Import Library/Add Library
// search for and install minim
import ddf.minim.*;
import ddf.minim.ugens.*;

// declare global variables for sound
Minim minim;
Oscil wave;
Pan pan;
AudioOutput out;


float panValue;

void setup(){
  // create a sketch
  size(400, 400, P2D);
  
  // create a minim object for sound
  minim = new Minim(this);
  
  // create a sine wave that is osccilating at 440 Hz, at 0.5 amplitude
  wave = new Oscil( 440 , 0.5f , Waves.SINE );
  
  // create a panning object that is intially set at center 
  // this object is a decimal point (float) range between -1 and 1
  // -1 represents only left speaker
  // 1 represents only right speaker
  // 0 represents centered sound equally sent to both left and right speakers
  pan = new Pan( 0 );
  
  // send stereo sound at 1024 samples per second "out" to default speakers
  // setting it to *stereo* allows us to pan between left and right speaker
  // default is *mono* which is only one channel of audio (not two)
  out = minim.getLineOut( minim.STEREO , 1024 );

  // Now link together minim's wave, pan, and output

  // send the wave to the panner
  wave.patch( pan );
  
  // send the panned wave to the output stereo speakers
  pan.patch( out );
  
}

void draw(){
  background(0);
  stroke(255);
  strokeWeight(1);
  
  //------------------------
  // update sound data setttings
  //------------------------

  // first "clear" the previous sound settings
  // so that we can update them with each drawn frame
  pan.unpatch( out);
  
  // reset the pan value based off of the ball's location
  float panValue = map( mouseX, 0, width, -1, 1 );
  pan.setPan( panValue );

  // reset the tone's frequency
  // right now this is just staying the same
  float freq = 200; //map( mouseX, 0, width, 110, 880 );
  wave.setFrequency( freq );
  
  // reset the amplitude (volume) based off the ball's location
  // closer to the paddle (the bottom) the louder it gets
  // look at the keypressed function for some fun
  float amp = map( mouseY, 0, height, 0, 1 );
  wave.setAmplitude( amp );
  
  // send the updated panned wave to the speakers
  pan.patch( out );
 
  // draw the ball
   ellipse(mouseX,mouseY,20,20);
  
  // draw a fake paddle
  rect(150,375,100,5);
 
  // draw the waveform of the output
  for(int i = 0; i < out.bufferSize() - 1; i++){
    // left sound
    line(50  - out.left.get(i)*50, i , 50  - out.left.get(i+1)*50 , i+1 );

    // right sound
    line( height - 50 - out.right.get(i)*50, i, width - 50 - out.right.get(i+1)*50, i+1 );
  }

}

//extra fun
void keyPressed(){ 
  switch( key )
  {
    case '1': 
      wave.setWaveform( Waves.SINE );
      break;
     
    case '2':
      wave.setWaveform( Waves.TRIANGLE );
      break;
     
    case '3':
      wave.setWaveform( Waves.SAW );
      break;
    
    case '4':
      wave.setWaveform( Waves.SQUARE );
      break;
      
    case '5':
      wave.setWaveform( Waves.QUARTERPULSE );
      break;
     
    default: break; 
  }
}
