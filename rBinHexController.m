//
//  rBinHexController.m
//  Bitmanipulator
//
//  Created by Sysadmin on 19.06.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import "rBinHexController.h"
#define   MAXLINE   255
#define   BASE      16.0


@implementation rBinHexController
- (id)init
{
	self=[super init];
	NSNotificationCenter * nc;
	nc=[NSNotificationCenter defaultCenter];

		[nc addObserver:self
			 selector:@selector(FensterSchliessenAktion:)
				  name:@"NSWindowWillCloseNotification"
				object:nil];

	return self;
}

- (void)awakeFromNib
{
	NSLog(@"awake");
   [TestFeld setIntValue:1];
	
}

- (IBAction)ClearAktion:(id)sender
{
int i;
   [TestFeld setIntValue:0];
	for (i=0;i<8;i++)
	{
	[[[sender superview]viewWithTag:i]setState:0];
	}
	[IntFeld setStringValue:@""];
	[BinFeld setStringValue:@""];
	[HexFeld setStringValue:@""];
	[WarnFeld setStringValue:@""];
}


- (IBAction)BinTasteAktion:(id)sender
{
	NSLog(@"BinTasteAktion: tag: %d state: %d",[sender tag],[sender state]);
	int i=[sender tag];
		NSMutableArray* BinArray=[[[NSMutableArray alloc]initWithCapacity:8]autorelease];

	for (i=0;i<8;i++)
	{
	[BinArray addObject:[NSNumber numberWithInt:[[[sender superview]viewWithTag:i]state]]];
	}
	[HexFeld setStringValue:[self HexStringAusBitArray:BinArray]];
	[IntFeld setIntValue:[self IntFromHexString:[self HexStringAusBitArray:BinArray]]];
	NSString* BinString=[NSString string];
	for (i=0;i<8;i++)
	
		{
		if ([[BinArray objectAtIndex:i]intValue])
		{
			BinString=[@"1" stringByAppendingString:BinString ];
		}
		else
		{
			BinString=[@"0"  stringByAppendingString:BinString];
		}
		//NSLog(@"BinString: %@",BinString);
	

	}
	[BinFeld setStringValue:BinString];
	NSLog(@"BinTasteAktion BinArray: %@",[BinArray description]);
	//[[[sender superview]viewWithTag:7-i]setState:1];
	
	
	
}

- (IBAction)IntFeldAktion:(id)sender
{
   [TestFeld setIntValue:[TestFeld intValue]+10];
	NSLog(@"IntFeldAktion: tag: %d string: %@",[sender tag],[sender stringValue]);
	if ([sender intValue]>0xFF)
	{
	[WarnFeld setStringValue:@"Zahl zu gross"];
	return;
	}
	[WarnFeld setStringValue:@" "];
	NSArray* BinArray=[self BinArrayFrom:[sender intValue]];
	NSLog(@"IntFeldAktion: BinArray: %@",[BinArray description]);
	
	[HexFeld setStringValue:[self HexStringFromInt:[sender intValue]]];
	
	[BinFeld setStringValue:[self BinStringFromInt:[sender intValue]]];
	int i;
	for (i=0;i<8;i++)
	{
		[[[sender superview]viewWithTag:i]setState:[[BinArray objectAtIndex:i]intValue]];
	}
	
	
	
}


- (IBAction)HexFeldAktion:(id)sender
{
	[TestFeld setIntValue:[TestFeld intValue]+1];
	NSString* HexCharString=@"0 1 2 3 4 5 6 7 8 9 a b c d e f A B C D E F";
	//NSArray* HexArray=[[HexString componentsSeparatedByString:@" "]retain];
	NSCharacterSet* HexSet=[NSCharacterSet characterSetWithCharactersInString:HexCharString];
	
	//NSLog(@"HexFeldAktion: tag: %d string: %@",[sender tag],[sender stringValue]);
	NSString* HexString=[sender stringValue];
	if ([HexString length]>2 )
	{
		[WarnFeld setStringValue:@"Mehr als 2 Zeichen!"];
		return;
	}
   if ([HexString length]==1 )
   {
      HexString = [@"0" stringByAppendingString:HexString];
      [sender setStringValue:HexString];
   
   }
	unichar c0=[HexString characterAtIndex:0];
	unichar c1=[HexString characterAtIndex:1];
	if (!([HexSet characterIsMember:c0]&&[HexSet characterIsMember:c1]))
	{
			[WarnFeld setStringValue:@"Falsche Ziffern!"];
		return;
	
	}
	[WarnFeld setStringValue:@" "];

	unsigned int returnInt=0;
	NSScanner* theScanner = [NSScanner scannerWithString:HexString];
	
	if ([theScanner scanHexInt:&returnInt])
	{
		//NSLog(@"HexStringZuInt string: %@ int: %x	",HexString,returnInt);
		
	}
	if (returnInt >0xFF)
	{
	[WarnFeld setStringValue:@"Zahl zu gross"];
	return;
	}
	[WarnFeld setStringValue:@" "];

	NSArray* BinArray=[self BinArrayFrom:returnInt];
	NSLog(@"HexFeldAktion: BinArray: %@",[BinArray description]);
	[IntFeld setIntValue:returnInt];
//
//	[BinFeld setStringValue:[BinArray componentsJoinedByString:@""]];
	[BinFeld setStringValue:[self BinStringFromInt:returnInt]];
//	[[[sender superview]viewWithTag:7]setState:1];
//return;

	int i;
	for (i=0;i<8;i++)
	{
		//NSLog(@"i: %d Wert: %d",i,[[BinArray objectAtIndex:i]intValue]);
		//NSLog(@"Button %@", [[[sender superview]viewWithTag:i]description]);
		[[[sender superview]viewWithTag:i]setState:[[BinArray objectAtIndex:i]intValue]];
		//NSLog(@"i: %d  state:  %d",i, [[[sender superview]viewWithTag:i]state]);
	}
	
}

- (NSString*)BinStringFromInt:(int)dieZahl
{	
	int pos=0;
	int rest=0;
	int zahl=dieZahl;
	
	NSString* BinString=[NSString string];
	while (zahl)
	{
		rest=zahl%2;
		if (rest)
		{
			BinString=[@"1" stringByAppendingString:BinString ];
		}
		else
		{
			BinString=[@"0"  stringByAppendingString:BinString];
		}
		zahl/=2;
		if (pos==3)
		{
		BinString=[@" " stringByAppendingString:BinString];
		}
		pos++;
		//NSLog(@"BinString: %@",BinString);
	}
	int i;
	for (i=pos;i<8;i++) //String mit fuehrenden Nullen ergänzen
	{
		BinString=[@"0"  stringByAppendingString:BinString];
	}
	return BinString;
}

- (NSArray*)BinArrayFrom:(int)dieZahl
{
	int rest=0;
	int zahl=dieZahl;
	NSLog(@"BinArray start: Zahl: %d",zahl);
	NSMutableArray* BinArray=[[[NSMutableArray alloc]initWithCapacity:8]autorelease];
	int anzStellen=0;
	while (zahl)
	{	
		
		rest=zahl%2;
		if (rest)
		{
			//NSLog(@"BinArray pos: %d Zahl: %d",anzStellen,1);
			[BinArray addObject:@"1"];
		}
		else
		{
			//NSLog(@"BinArray pos: %d Zahl: %d",anzStellen,0);

			[BinArray addObject:@"0"];
		}
		zahl/=2;
		anzStellen++;
	}
	//NSLog(@"BinArray: %@",[BinArray description]);
	int i;
	for (i=anzStellen;i<8;i++)
	{
	[BinArray addObject:@"0"];
	}
	return BinArray;
}

- (NSString*)HexStringFromInt:(int)dieZahl
{
	NSString* HexString=@"0 1 2 3 4 5 6 7 8 9 A B C D E F";
	NSArray* HexArray=[[HexString componentsSeparatedByString:@" "]retain];
	int zahl=dieZahl;
	int rest=0;
	NSString* hexString=[NSString string];
	//NSLog(@"HexStringFromInt: HexArray: %@ dieZahl: %d",[HexArray description],dieZahl);
	while (zahl)
	{
		
		rest=zahl%16;
		//NSLog(@"HexStringFromInt: zahl: %d rest: %d",zahl,rest);
		//NSLog(@"hex: %@",[HexArray objectAtIndex:rest]);
		hexString=[[HexArray objectAtIndex:rest] stringByAppendingString:hexString ];
		//NSLog(@"hexString: %@",hexString);
		zahl/=16;
		rest=0;
		
	
	
	}//while
	
	//NSLog(@"hexString: %@",hexString);
	return hexString;

}

- (int)IntFromHexString:(NSString*) derHexString
{
	unsigned int returnInt=0;
	NSScanner* theScanner = [NSScanner scannerWithString:derHexString];
	
	if ([theScanner scanHexInt:&returnInt])
	{
		NSLog(@"HexStringZuInt string: %@ int: %x	",derHexString,returnInt);
		return returnInt;
	}
	
	return returnInt;
}


- (NSString*)HexStringAusBitArray:(NSArray*)derBitArray
{
	NSString* HexString=@"0 1 2 3 4 5 6 7 8 9 A B C D E F";
	NSArray* HexArray=[[HexString componentsSeparatedByString:@" "]retain];
	NSCharacterSet* HexSet=[NSCharacterSet characterSetWithCharactersInString:HexString];
	
	int i;
	int h=0;
	int l=0;
	//NSLog(@"BitArray: %@ Anz:%d",[derBitArray description],[derBitArray count]);

	for (i=0;i<4;i++)
	{
		if ([[derBitArray objectAtIndex:i]intValue])
		{
			l=l+pow(2,i);
			//NSLog(@"HexAusBitArray: i %d l: %d",i,l);
		}
		if ([[derBitArray objectAtIndex:i+4]intValue])
		{
			h=h+pow(2,i);
			//NSLog(@"HexAusBitArray: i %d h: %d",i,h);
		}
		
	}//for i
	NSString* lsb=[HexArray objectAtIndex:l];
	NSString* msb=[HexArray objectAtIndex:h];
	
	//NSLog(@"msb: %@ lsb: %@",msb,lsb);
	return [msb stringByAppendingString:lsb];
}



/* htoi() converts a string of hexadecimal digits (including
   an optional 0x or 0X) into its equivalent integer value.
   The allowable digits are 0 through 9, a through f,
   and A through F. */
int htoi(char str[])
{

    int value = 0,  /* the sum of the hexadecimal digits' equivalent
                       decimal values */
           weight,  /* the weight of a hexadecimal digit place */   
            digit,
            i = 0,  /* array index */
              len,  /* length of string */
                c;  /* character */            
   
    /* report error on empty string */
    if (str[i] == '\0')
        return -1;
        
    /* ignore 0x or 0X in hexidecimal string */
    if (str[i] == '0') {
        ++i;
        if (str[i] == 'x' || str[i] == 'X')
            ++i;
    }
    
    len = strlen(str);    
    
    /* calculate each hex character's decimal value */
    for ( ; i < len; ++i) {
        c = tolower(str[i]);
        if (c >= '0' && c <= '9')
            digit = c - '0';
        else if (c >= 'a' && c <= 'f') {
            switch (c) {
                case 'a':
                    digit = 10;
                    break;
                case 'b':
                    digit = 11;
                    break;
                case 'c':
                    digit = 12;
                    break;
                case 'd':
                    digit = 13;
                    break;
                case 'e':
                    digit = 14;
                    break;
                case 'f':
                    digit = 15;
                    break;
                default:
                    break;
            }
        }
        else
            return -1;  /* invalid input encountered */
        
        weight = (int) pow(BASE, (double) (len - i - 1));
        value += weight * digit;
    }
    return value;
}

- (void) FensterSchliessenAktion:(NSNotification*)note
{
	NSLog(@"FensterSchliessenAktion: %@ anz Window: %d",[[note object]description],[[NSApp windows]count]);
	{
		
		[NSApp terminate:self];
		
	}
	//return YES;
}

@end
