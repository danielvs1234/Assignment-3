/*
 * generated by Xtext 2.21.0
 */
package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import javax.swing.JOptionPane
import java.util.HashMap
import org.xtext.example.mydsl.mathCompiler.MathExp
import org.xtext.example.mydsl.mathCompiler.Plus
import org.xtext.example.mydsl.mathCompiler.Minus
import org.xtext.example.mydsl.mathCompiler.Mult
import org.xtext.example.mydsl.mathCompiler.Div
import org.xtext.example.mydsl.mathCompiler.Num
import org.xtext.example.mydsl.mathCompiler.Var
import org.xtext.example.mydsl.mathCompiler.Let
import org.xtext.example.mydsl.mathCompiler.Expression
import java.util.Map
import java.util.ArrayList
import org.xtext.example.mydsl.mathCompiler.AbstractExpression
import org.xtext.example.mydsl.mathCompiler.Pow
import org.xtext.example.mydsl.mathCompiler.Mod

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathCompilerGenerator extends AbstractGenerator {
		
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val math = resource.allContents.filter(MathExp).next
		printClass(math, fsa)
	}
	
	
	def String displayExp(Expression exp) {
		switch exp {
			Plus: exp.left.displayExp+"+"+exp.right.displayExp
			Minus: exp.left.displayExp+"-"+exp.right.displayExp
			Mult: exp.left.displayExp+"*"+exp.right.displayExp
			Div: exp.left.displayExp+"/"+exp.right.displayExp
			Pow: exp.left.displayExp+"^"+exp.right.displayExp
			Mod: exp.left.displayExp+"%"+exp.right.displayExp
			Num: Integer.toString(exp.value)
			Var: exp.id
			Let: '''let �exp.id� = �exp.binding.displayExp� in �exp.body.displayExp� end'''
			default: throw new Error("Invalid expression")
		}
	}
	
	def String getLeftExp(Expression exp) {
		switch exp {
			Plus: exp.left.displayExp
			Minus: exp.left.displayExp
			Mult: exp.left.displayExp
			Div: exp.left.displayExp
			Pow: exp.left.displayExp
			Mod: exp.left.displayExp
			Num: Integer.toString(exp.value)
			Var: exp.id
			Let: '''let �exp.id� = �exp.binding.displayExp� in �exp.body.displayExp� end'''
			default: throw new Error("Invalid expression")
		}
	}
		def String getRightExp(Expression exp) {
		switch exp {
			Plus: exp.right.displayExp
			Minus: exp.right.displayExp
			Mult: exp.right.displayExp
			Div: exp.right.displayExp		
			Pow: exp.right.displayExp
			Mod: exp.right.displayExp
			Num: Integer.toString(exp.value)
			Var: exp.id
			Let: '''let �exp.id� = �exp.binding.displayExp� in �exp.body.displayExp� end'''
			default: throw new Error("Invalid expression")
		}
	}
	
	
	def printClass(MathExp math, IFileSystemAccess2 fsa){
		
		var javaClass = '''
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
				�FOR AbstractExpression e : math.abstractExpression�
				�IF e.exp instanceof org.xtext.example.mydsl.mathCompiler.Pow�
				System.out.println("�e.label.toString()� : " + power(�e.exp.leftExp�,�e.exp.rightExp�));
				�ELSEIF e.exp instanceof org.xtext.example.mydsl.mathCompiler.Mod�
				System.out.println("�e.label.toString()� : " + modulus(�e.exp.leftExp�,�e.exp.rightExp�));
				�ELSE�
				System.out.println("�e.label.toString()� : " + �e.exp.displayExp�);			
				�ENDIF�
				�ENDFOR� 
			}
		}
		'''
		
		fsa.generateFile("MathCompiler.java", javaClass)
	}
		
}
