//
//  JSON.swift
//  AppTests
//
//  Created by sean on 2022/10/10.
//

import Foundation

struct JSON {
  
  static let roleSkills = """
  {
    \"result\" : \"SUCCESS\",
    \"data\" : [
      {
        \"code_cd\" : \"DEV\",
        \"code_nm\" : \"개발자\",
        \"codes\" : [
          {
            \"code_id\" : 16,
            \"code_cd\" : \"REACT\",
            \"code_nm\" : \"React\"
          },
          {
            \"code_id\" : 28,
            \"code_cd\" : \"UNREAL_ENGINE\",
            \"code_nm\" : \"Unreal Engine\"
          },
          {
            \"code_id\" : 29,
            \"code_cd\" : \"TRHEE_JS\",
            \"code_nm\" : \"Three.js\"
          },
          {
            \"code_id\" : 30,
            \"code_cd\" : \"FLASK\",
            \"code_nm\" : \"Flask\"
          },
          {
            \"code_id\" : 31,
            \"code_cd\" : \"AI\",
            \"code_nm\" : \"AI\"
          },
          {
            \"code_id\" : 32,
            \"code_cd\" : \"BLOCK_CHAIN\",
            \"code_nm\" : \"Blockchain\"
          },
          {
            \"code_id\" : 33,
            \"code_cd\" : \"GO\",
            \"code_nm\" : \"Go\"
          },
          {
            \"code_id\" : 34,
            \"code_cd\" : \"AWS\",
            \"code_nm\" : \"AWS\"
          },
          {
            \"code_id\" : 35,
            \"code_cd\" : \"DOCKER\",
            \"code_nm\" : \"Docker\"
          },
          {
            \"code_id\" : 27,
            \"code_cd\" : \"UNITY\",
            \"code_nm\" : \"Unity\"
          },
          {
            \"code_id\" : 26,
            \"code_cd\" : \"SVELTE\",
            \"code_nm\" : \"Svelte\"
          },
          {
            \"code_id\" : 25,
            \"code_cd\" : \"VUE_JS\",
            \"code_nm\" : \"Vue.js\"
          },
          {
            \"code_id\" : 17,
            \"code_cd\" : \"NEST_JS\",
            \"code_nm\" : \"Next.js\"
          },
          {
            \"code_id\" : 18,
            \"code_cd\" : \"NODE_JS\",
            \"code_nm\" : \"Node.js\"
          },
          {
            \"code_id\" : 19,
            \"code_cd\" : \"DJANGO\",
            \"code_nm\" : \"Django\"
          },
          {
            \"code_id\" : 20,
            \"code_cd\" : \"SPRING\",
            \"code_nm\" : \"Spring\"
          },
          {
            \"code_id\" : 21,
            \"code_cd\" : \"IOS\",
            \"code_nm\" : \"iOS\"
          },
          {
            \"code_id\" : 22,
            \"code_cd\" : \"ANDROID\",
            \"code_nm\" : \"Android\"
          },
          {
            \"code_id\" : 23,
            \"code_cd\" : \"REACT_NATIVE\",
            \"code_nm\" : \"React-Native\"
          },
          {
            \"code_id\" : 24,
            \"code_cd\" : \"FLUTTER\",
            \"code_nm\" : \"Flutter\"
          },
          {
            \"code_id\" : 36,
            \"code_cd\" : \"KUBERNATES\",
            \"code_nm\" : \"Kubernetes\"
          }
        ]
      },
      {
        \"code_cd\" : \"MAK\",
        \"code_nm\" : \"마케터\",
        \"codes\" : [
          {
            \"code_id\" : 46,
            \"code_cd\" : \"UA\",
            \"code_nm\" : \"UA\"
          },
          {
            \"code_id\" : 56,
            \"code_cd\" : \"FACEBOOK\",
            \"code_nm\" : \"Facebook\"
          },
          {
            \"code_id\" : 55,
            \"code_cd\" : \"PREMIERE_PRO\",
            \"code_nm\" : \"Premiere Pro\"
          },
          {
            \"code_id\" : 54,
            \"code_cd\" : \"AFFTER_EFFECT\",
            \"code_nm\" : \"AfterEffect\"
          },
          {
            \"code_id\" : 53,
            \"code_cd\" : \"ILLUSTRATOR\",
            \"code_nm\" : \"Illustrator\"
          },
          {
            \"code_id\" : 52,
            \"code_cd\" : \"PHOTOSHOP\",
            \"code_nm\" : \"Photoshop\"
          },
          {
            \"code_id\" : 51,
            \"code_cd\" : \"GOOGLE_SPREADSHEET\",
            \"code_nm\" : \"Google Spreadsheet\"
          },
          {
            \"code_id\" : 50,
            \"code_cd\" : \"EXCEL\",
            \"code_nm\" : \"Excel\"
          },
          {
            \"code_id\" : 49,
            \"code_cd\" : \"AMPLITUDE\",
            \"code_nm\" : \"Amplitude\"
          },
          {
            \"code_id\" : 48,
            \"code_cd\" : \"FIREBASE\",
            \"code_nm\" : \"Firebase\"
          },
          {
            \"code_id\" : 47,
            \"code_cd\" : \"GA4\",
            \"code_nm\" : \"GA4\"
          },
          {
            \"code_id\" : 57,
            \"code_cd\" : \"INSTAGRAM\",
            \"code_nm\" : \"Instagram\"
          }
        ]
      },
      {
        \"code_cd\" : \"DESIGN\",
        \"code_nm\" : \"디자이너\",
        \"codes\" : [
          {
            \"code_id\" : 6,
            \"code_cd\" : \"FIGMA\",
            \"code_nm\" : \"Figma\"
          },
          {
            \"code_id\" : 44,
            \"code_cd\" : \"ILLUSTRATOR\",
            \"code_nm\" : \"Illustrator\"
          },
          {
            \"code_id\" : 43,
            \"code_cd\" : \"PHOTOSHOP\",
            \"code_nm\" : \"Photoshop\"
          },
          {
            \"code_id\" : 42,
            \"code_cd\" : \"ZEPLIN\",
            \"code_nm\" : \"Zeplin\"
          },
          {
            \"code_id\" : 41,
            \"code_cd\" : \"PRINCIPLE\",
            \"code_nm\" : \"Principle\"
          },
          {
            \"code_id\" : 40,
            \"code_cd\" : \"INVISION\",
            \"code_nm\" : \"Invision\"
          },
          {
            \"code_id\" : 39,
            \"code_cd\" : \"PROTOPIE\",
            \"code_nm\" : \"Protopie\"
          },
          {
            \"code_id\" : 38,
            \"code_cd\" : \"ADOBE_XD\",
            \"code_nm\" : \"AdobeXD\"
          },
          {
            \"code_id\" : 37,
            \"code_cd\" : \"SKETCH\",
            \"code_nm\" : \"Sketch\"
          },
          {
            \"code_id\" : 45,
            \"code_cd\" : \"AFTER_EFFECT\",
            \"code_nm\" : \"AfterEffect\"
          }
        ]
      },
      {
        \"code_cd\" : \"PM\",
        \"code_nm\" : \"기획자\",
        \"codes\" : [
          {
            \"code_id\" : 5,
            \"code_cd\" : \"FIGMA\",
            \"code_nm\" : \"Figma\"
          },
          {
            \"code_id\" : 7,
            \"code_cd\" : \"UA\",
            \"code_nm\" : \"UA\"
          },
          {
            \"code_id\" : 8,
            \"code_cd\" : \"GA4\",
            \"code_nm\" : \"GA4\"
          },
          {
            \"code_id\" : 9,
            \"code_cd\" : \"FIREBASE\",
            \"code_nm\" : \"Firebase\"
          },
          {
            \"code_id\" : 10,
            \"code_cd\" : \"AMPLITUDE\",
            \"code_nm\" : \"Amplitude\"
          },
          {
            \"code_id\" : 14,
            \"code_cd\" : \"EXCEL\",
            \"code_nm\" : \"Excel\"
          },
          {
            \"code_id\" : 13,
            \"code_cd\" : \"PYTHON\",
            \"code_nm\" : \"Python\"
          },
          {
            \"code_id\" : 12,
            \"code_cd\" : \"SQL\",
            \"code_nm\" : \"SQL\"
          },
          {
            \"code_id\" : 11,
            \"code_cd\" : \"APPSFLYR\",
            \"code_nm\" : \"Appsflyr\"
          },
          {
            \"code_id\" : 15,
            \"code_cd\" : \"GOOGLE_SPREADSHEET\",
            \"code_nm\" : \"Google Spreadsheet\"
          }
        ]
      }
    ],
    \"message\" : null,
    \"error_code\" : null
  }
  """
  
  static let profile = """
{
  \"result\" : \"SUCCESS\",
  \"data\" : {
    \"region\" : {
      \"regionCode\" : 1165000000,
      \"regionName\" : \"서울 서초구\"
    },
    \"career\" : \"JUNIOR\",
    \"interesting\" : [
      \"FINANCE\"
    ],
    \"nickname\" : \"Naveruser\",
    \"role\" : [
      \"DEV\"
    ],
    \"profile_url\" : \"https://ssl.pstatic.net/static/pwe/address/img_profile.png\",
    \"skills\" : [
      \"iOS\"
    ],
    \"terms\" : null,
    \"auth_type\" : \"NAVER\",
    \"portfolio_url\" : \"\"
  },
  \"message\" : null,
  \"error_code\" : null
}
"""
}
