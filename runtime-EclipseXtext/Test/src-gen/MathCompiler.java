public class MathCompiler{
	public MathCompiler(){
		}
	
	public double power(int base, int exponent){
		return Math.pow(base, exponent);
	}
	
	public int modulus(int a, int b){
		return Math.floorMod (a,b);
	}
	public void calculate() {
		System.out.println("first : " + 2+2);			
		System.out.println("second : " + 23+2);			
		System.out.println("third : " + power(23,2));
		System.out.println("fourth : " + modulus(9,2));
	}
}
