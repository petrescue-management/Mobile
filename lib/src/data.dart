import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pet_rescue_mobile/src/style.dart';
import 'package:pet_rescue_mobile/views/home_page.dart';
import 'package:pet_rescue_mobile/views/login/login_request.dart';

final List<String> imgList = [
  'https://thecatandthedog.com/wp-content/uploads/2020/11/petcare-large.jpg',
  'https://img.etimg.com/thumb/msid-76546023,width-640,resizemode-4,imgsize-918765/pet-care-tips.jpg',
  'https://cdn.corporate.walmart.com/dims4/WMT/6cb59be/2147483647/strip/true/crop/2000x1304+0+13/resize/920x600!/quality/90/?url=https%3A%2F%2Fcdn.corporate.walmart.com%2Fd7%2F66%2Fad4a88bd4a09bfffe44b1f604ecf%2Fwalmart-pet-care-lead-image.jpg',
];

final String mapKey = 'AIzaSyAZ4pja68qoa62hCzFdlmAu30iAb_CgmTk';

final List<Widget> isNotLoggedInPages = [
  HomePage(key: PageStorageKey('HomePage')),
  LoginRequest(key: PageStorageKey('LoginRequest')),
];

final isNotLoggedInBottomNavItems = [
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.login),
    label: 'Login Request',
  ),
];

final adoptionPolicy = RichText(
  text: TextSpan(
    style: TextStyle(
      fontFamily: 'SamsungSans',
      color: darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 1.3,
    ),
    children: [
      TextSpan(
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        text:
            'Trước khi quyết định nhận nuôi bé chó hay mèo nào, bạn hãy tự hỏi bản thân rằng mình đã sẵn sàng để chịu trách nhiệm cả đời cho bé chưa, cả về tài chính, nơi ở cũng như tinh thần.\n',
      ),
      TextSpan(
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        text:
            'Việc nhận nuôi cần được sự đồng thuận lớn từ bản thân bạn cũng như gia đình và những người liên quan. Xin cân nhắc kỹ trước khi đăng ký nhận nuôi các bé.\n\n',
      ),
      TextSpan(
        text: 'BẠN ĐÃ SẴN SÀNG? Hãy lưu ý những diều sau:\n\n',
      ),
      TextSpan(
        text:
            '- Đa số các bé được cứu về trong tình trạng tồi tệ, tinh thần không tốt, nên việc đi xa sẽ khó cho các bé. Những bạn ở xa nơi trung tâm quản lý bé hãy hết sức lưu ý diều này.\n',
      ),
      TextSpan(
        text:
            '- Sau khi đăng ký nhận nuôi, trung tâm cứu hộ sẽ liên hệ phỏng vấn bạn vài điều. Phần phỏng vấn có thể có nhiều câu hỏi mang tính chất riêng tư, vì vậy mong bạn hãy kiên nhẫn nhé!\n',
      ),
      TextSpan(
        text:
            '- Trung tâm cứu hộ sẽ thu một khoản tiền vía (bao gồm các khoản chi về y tế trước đây cho bé, cũng như để hỗ trợ chi phí chăm sóc, nuôi dưỡng các bé khác tại nhà chung).\n',
      ),
      TextSpan(
        text:
            '- Tiền vía mỗi bé sẽ khác nhau tùy thuộc vào tình trạng của bé khi cứu cũng như các dịch vụ y tế (tiêm phòng, triệt sản) đã thực hiện.\n',
      ),
      TextSpan(
        text:
            '- Sau khi mang các bé về nuôi, bạn cần cập nhật trạng thái của các bé trong 3 tháng để phía trung tâm theo dõi tình trạng sức khỏe cũng như đảm bảo các bé về đúng nhà.\n',
      ),
      TextSpan(
        text:
            '- Trường hợp bạn không nuôi được tiếp cần trả lại cho trung tâm cứu hộ, không tự ý đem cho người khác.\n',
      ),
    ],
  ),
);

final volunteerPolicy = RichText(
  text: TextSpan(
    style: TextStyle(
      fontFamily: 'SamsungSans',
      color: darkBlue,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      height: 1.3,
    ),
    children: [
      TextSpan(
        style: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        text:
            ' Hiện tại số lượng chó mèo cần cứu hộ đang tăng dần, nhưng số lượng tình nguyện viên còn khá khiêm tốn nên không thể đảm bảo cho việc cứu hộ các bé kịp thời nhanh nhất và tốt nhất.\n',
      ),
      TextSpan(
          style: TextStyle(
            fontStyle: FontStyle.italic,
          ),
          text:
              ' Chúng tôi rất hy vọng có thêm được sự giúp đỡ từ bạn bằng cách tham gia làm tình nguyện viên cứu hộ.\n\n'),
      TextSpan(
        text:
            'Trước khi đăng ký làm tình nguyện viên cứu hộ, bạn hãy cân nhắc những yêu cầu sau:\n',
      ),
      TextSpan(
          text:
              '- Những công việc này đều là không lương, nhưng lại cần có trách nhiệm và tình cảm thật sự trong đó. Bởi nếu chỉ tham gia cho vui hay ý thích nhất thời thì bạn không thể làm được lâu dài và ảnh hưởng ít nhiều đến các bé.\n'),
      TextSpan(
        text:
            '- Có thời gian (sẽ hạn chế nhận các bạn học sinh đang trong giai đoạn ôn thi).\n',
      ),
      TextSpan(
        text: '- Yêu thương và muốn thực sự góp sức cứu các bé.\n',
      ),
      TextSpan(
        text: '- Có xe máy, chủ động được phương tiện đi lại.\n',
      ),
      TextSpan(
        text:
            '- Tay lái cứng, có thể giúp chuyển các bé về trung tâm cứu hộ, vận chuyển lồng chuồng.\n',
      ),
    ],
  ),
);
