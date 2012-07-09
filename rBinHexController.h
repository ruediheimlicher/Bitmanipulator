//
//  rBinHexController.h
//  Bitmanipulator
//
//  Created by Sysadmin on 19.06.08.
//  Copyright 2008 Ruedi Heimlicher. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface rBinHexController : NSWindowController 
{
uint8_t		hexWert;
IBOutlet id Bintaste;
IBOutlet id  HexFeld;
IBOutlet id  BinFeld;
IBOutlet id  IntFeld;
IBOutlet id  WarnFeld;
rBinHexController* BinHexController;
}

- (IBAction)BinTasteAktion:(id)sender;
- (IBAction)HexFeldAktion:(id)sender;
- (IBAction)IntFeldAktion:(id)sender;
- (NSString*)BinStringFromInt:(int)dieZahl;
- (NSString*)HexStringFromInt:(int)dieZahl;
- (NSString*)HexStringAusBitArray:(NSArray*)derBitArray;
- (NSArray*)BinArrayFrom:(int)dieZahl;
- (IBAction)ClearAktion:(id)sender;
- (int)IntFromHexString:(NSString*) derHexString;
@end
