// First exersise of OCS.
import acm.program.*;
public class OSCEx1 extends Program {
	public void run() {
		// Instantiation of counter of each value.
		int euros,cents,ammount,ce10,ce5,ce2,ce1,cc50,cc20,cc10,cc5,cc2,cc1;
		euros = cents = ce10 = ce5 = ce1 = cc50 = cc20 = cc10 = cc5 = cc2 = cc1 = 0;
		final String err_msg = "Error! Please try again.";
		// Start message
		println("--Parking Ticket Payment--\n");
		println("Fee: 5 euros and 24 cents\n");
		// Imput prompt message
		euros = readInt("Euros: (<=20): ");
		cents = readInt("Cents: (<=99): ");
		println("");
		// Calculation of change
		if (euros<=20 && euros>=0 && cents<=99 && cents>=0) {
			if(euros==5 && cents==24) {
				println("Change = 0");
			} else {
				ammount = euros*100 + cents;
				ammount -= 524;
				ce10 = ce5 = ce2 = ce1 = 0;
				if(ammount >=1000) {
					ce10++;
					ammount-=1000;
				}
				if(ammount >=500) {
					ce5++;
					ammount-=500;
				}
				while(true) {
					if(ammount >=200) {
						ce2++;
						ammount-=200;
					} else {
						break;
					}
				}
				if(ammount >=100) {
					ce1++;
					ammount-=100;
				}
				if(ammount >=50) {
					cc50++;
					ammount-=50;
				}
				while(true) {
					if(ammount >=20) {
						cc20++;
						ammount-=20;
					} else {
						break;
					}
				}
				if(ammount >=10) {
					cc10++;
					ammount-=10;
				}
				if(ammount >=5) {
					cc5++;
					ammount-=5;
				}
				while(true) {
					if(ammount >=2) {
						cc2++;
						ammount-=2;
					} else {
						break;
					}
				}
				if(ammount >=1) {
					cc1++;
					ammount-=1;
				}
				println("Change: \n");
				if (ce10!=0) println(ce10+" x 10 euros");
				if (ce5!=0) println(ce5+" x 5 euros");
				if (ce2!=0) println(ce2+" x 2 euros");
				if (ce1!=0) println(ce1+" x 1 euros");
				if (cc50!=0) println(cc50+" x 50 cents");
				if (cc20!=0) println(cc20+" x 20 cents");
				if (cc10!=0) println(cc10+" x 10 cents");
				if (cc5!=0) println(cc5+" x 5 cents");
				if (cc2!=0) println(cc2+" x 2 cents");
				if (cc1!=0) println(cc1+" x 1 cents");				
			}
		} else {
			println(err_msg);
		}		
	}
}