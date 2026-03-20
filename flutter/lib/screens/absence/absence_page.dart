import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rt_app/widgets/app_top_bar.dart';
import 'package:rt_app/style/colors.dart';
import 'package:rt_app/style/fonts.dart';
import 'package:rt_app/utils/constants.dart';
import 'package:rt_app/auth/auth_provider.dart';
import 'package:rt_app/features/absence/state/absence_provider.dart';



class AbsencePage extends StatefulWidget {
  @override
  _AbsencePageState createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _showAbsenceDataModal = false;
  bool _showBitrixSuccessModal = false;
  String _processedText = '';


  // Simulate processing and server mutation
  Future<void> _processMessage() async {
    if (_controller.text.isEmpty) return;
    
    setState(() {
      _isLoading = true;
      _showAbsenceDataModal = false;
    });

    // Simulate API processing delay
    final absenceProvider = context.read<AbsenceProvider>();
    final absence = await absenceProvider.createAbsenceData(_controller.text);

    setState(() {
      _isLoading = false;
      _processedText = 'Processed: ${_controller.text} (AI response here)';
      _showAbsenceDataModal = true;
    });
  }

  Future<void> _sendMutation() async {
    setState(() {
      _showAbsenceDataModal = false;
      _showBitrixSuccessModal = true;
    });

    // Simulate server mutation
    await Future.delayed(Duration(seconds: 1));

    // Auto-dismiss success modal and clear text
    Timer(Duration(seconds: 2), () {
      setState(() {
        _showBitrixSuccessModal = false;
        _controller.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final SW = MediaQuery.of(context).size.width;
    final SH = MediaQuery.of(context).size.height;

    final absenceProvider = context.watch<AbsenceProvider>();
    if (absenceProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final absence = absenceProvider.getAbsence;

    return GestureDetector(
      behavior: HitTestBehavior.opaque, 
      onTap: () {
        FocusScope.of(context).unfocus();
      }, 
      child: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SW * 0.1),
	      child: TextField(
		maxLines: null,
		minLines: 1,
	        controller: _controller,
	        textAlign: TextAlign.center,
		cursorColor: RTColorStyle.beige700.value,
	        decoration: InputDecoration(
	          hintText: 'Введите данные...',
		  hintStyle: TextStyle(                    
		    color: RTColorStyle.light500.value,   
  		    fontSize: 16,                        
  		    fontWeight: FontWeight.w400,          
		    fontFamily: "MuseoSans",
  		  ),
	          border: OutlineInputBorder(
	            borderRadius: BorderRadius.circular(20),
	          ),
		  enabledBorder: OutlineInputBorder(
		    borderRadius: BorderRadius.circular(20),
    		    borderSide: BorderSide(
    		      color: RTColorStyle.light500.value,
    		      width: 1.0,
    		    ),
    		  ),
		  focusedBorder: OutlineInputBorder(
		    borderRadius: BorderRadius.circular(20),
    		    borderSide: BorderSide(
    		      color: RTColorStyle.beige800.value, 
    		      width: SW * 0.003,
    		    ),
    		  ),
	          suffixIcon: Row(
	            mainAxisSize: MainAxisSize.min,
	            children: [
	              ElevatedButton(
	                onPressed: _isLoading ? null : _processMessage,
	                style: ElevatedButton.styleFrom(
	                  shape: CircleBorder(),
			  minimumSize: Size(SW * 0.09, SW * 0.09),  
			  padding: EdgeInsets.all(0),
	                ),
	                child: Icon(Icons.send, size: SW * 0.046, color: RTColorStyle.dark800.value),
	              ),
	              ElevatedButton(
	                onPressed: _isLoading ? null : () {
	                  ScaffoldMessenger.of(context).showSnackBar(
	                    SnackBar(content: Text('Audio recording not implemented')),
	                  );
	                },
	                style: ElevatedButton.styleFrom(
	                  backgroundColor: RTColorStyle.beige700.value,
	                  shape: CircleBorder(),
			  minimumSize: Size(SW * 0.09, SW * 0.09), 
			  padding: EdgeInsets.all(0),
	                ),
	                child: Icon(Icons.mic, size: SW * 0.046, color: Colors.white),
	              ),
		      SizedBox(width: SW * 0.02),
	            ],
	          ),
	        ),
	        enabled: !_isLoading,
	      ),

              //child: Row(
              //  mainAxisAlignment: MainAxisAlignment.center,
              //  children: [
              //    Expanded(
              //      child: SizedBox(
              //        width: double.infinity,
              //        child: TextField(
              //          controller: _controller,
              //          textAlign: TextAlign.center,
              //          decoration: InputDecoration(
              //            hintText: 'Введите дату и время отсутствия...',
              //            border: OutlineInputBorder(
              //              borderRadius: BorderRadius.circular(25),
              //            ),
              //            contentPadding: EdgeInsets.symmetric(
              //              horizontal: 20,
              //              vertical: 15,
              //            ),
              //          ),
              //          enabled: !_isLoading,
              //        ),
              //      ),
              //    ),
              //    SizedBox(width: 12),
              //    // Send button
              //    ElevatedButton(
              //      onPressed: _isLoading ? null : _processMessage,
              //      style: ElevatedButton.styleFrom(
              //        shape: CircleBorder(),
              //        padding: EdgeInsets.all(16),
              //      ),
              //      child: Icon(Icons.send, size: 24),
              //    ),
              //    SizedBox(width: 8),
              //    // Audio record button
              //    ElevatedButton(
              //      onPressed: _isLoading ? null : () {
              //        // TODO: Implement audio recording + STT
              //        ScaffoldMessenger.of(context).showSnackBar(
              //          SnackBar(content: Text('Audio recording not implemented')),
              //        );
              //      },
              //      style: ElevatedButton.styleFrom(
              //        backgroundColor: Colors.blue,
              //        shape: CircleBorder(),
              //        padding: EdgeInsets.all(16),
              //      ),
              //      child: Icon(Icons.mic, size: 24, color: Colors.white),
              //    ),
              //  ],
              //),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),

          // First modal (processed text + yes/no)
          if (_showAbsenceDataModal)
            GestureDetector(
              onTap: () {}, // Prevent closing on outside tap
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Установить отсутствие \nс: ${absence!.timeFromFormatted} \nпо: ${absence!.timeToFormatted}\n по причине: ${absence!.typeOfAbsenceName}?" ?? "ABSENCE: ",
                          style: TextStyle(
			    fontSize: 16,
			    color: Colors.black,
			    ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                setState(() => _showAbsenceDataModal = false);
                                // Text stays in field (no clear)
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                              ),
                              child: Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: _sendMutation,
                              child: Text('Yes'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Success modal
          if (_showBitrixSuccessModal)
            GestureDetector(
              onTap: () {}, // Prevent closing on outside tap
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Message sent successfully!',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
	),
      );
  }
}

