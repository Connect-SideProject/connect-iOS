//
//  JSON.swift
//  AppTests
//
//  Created by sean on 2022/10/10.
//

import Foundation

public struct JSON {
  
  public static let interests = """
  {
      \"result\" : \"SUCCESS\",
      \"data\" : [
        {
          \"sort_num\": 58,
          \"code_cd\": \"FINANCE\",
          \"code_nm\": \"금융\"
        },
        {
          \"sort_num\": 59,
          \"code_cd\": \"FATION\",
          \"code_nm\": \"패션\"
        },
        {
          \"sort_num\": 60,
          \"code_cd\": \"ENTERTAIN\",
          \"code_nm\": \"예능\"
        },
        {
          \"sort_num\": 61,
          \"code_cd\": \"HEALTH\",
          \"code_nm\": \"건강\"
        }],
      \"message\" : null,
      \"error_code\" : null
  }
  """
  
  public static let roleSkills = """
  {
    \"result\" : \"SUCCESS\",
    \"data\" : [
      {
        \"code_cd\" : \"DEV\",
        \"code_nm\" : \"개발자\",
        \"codes\" : [
          {
            \"sort_num\" : 16,
            \"code_cd\" : \"REACT\",
            \"code_nm\" : \"React\"
          },
          {
            \"sort_num\" : 28,
            \"code_cd\" : \"UNREAL_ENGINE\",
            \"code_nm\" : \"Unreal Engine\"
          },
          {
            \"sort_num\" : 29,
            \"code_cd\" : \"TRHEE_JS\",
            \"code_nm\" : \"Three.js\"
          },
          {
            \"sort_num\" : 30,
            \"code_cd\" : \"FLASK\",
            \"code_nm\" : \"Flask\"
          },
          {
            \"sort_num\" : 31,
            \"code_cd\" : \"AI\",
            \"code_nm\" : \"AI\"
          },
          {
            \"sort_num\" : 32,
            \"code_cd\" : \"BLOCK_CHAIN\",
            \"code_nm\" : \"Blockchain\"
          },
          {
            \"sort_num\" : 33,
            \"code_cd\" : \"GO\",
            \"code_nm\" : \"Go\"
          },
          {
            \"sort_num\" : 34,
            \"code_cd\" : \"AWS\",
            \"code_nm\" : \"AWS\"
          },
          {
            \"sort_num\" : 35,
            \"code_cd\" : \"DOCKER\",
            \"code_nm\" : \"Docker\"
          },
          {
            \"sort_num\" : 27,
            \"code_cd\" : \"UNITY\",
            \"code_nm\" : \"Unity\"
          },
          {
            \"sort_num\" : 26,
            \"code_cd\" : \"SVELTE\",
            \"code_nm\" : \"Svelte\"
          },
          {
            \"sort_num\" : 25,
            \"code_cd\" : \"VUE_JS\",
            \"code_nm\" : \"Vue.js\"
          },
          {
            \"sort_num\" : 17,
            \"code_cd\" : \"NEST_JS\",
            \"code_nm\" : \"Next.js\"
          },
          {
            \"sort_num\" : 18,
            \"code_cd\" : \"NODE_JS\",
            \"code_nm\" : \"Node.js\"
          },
          {
            \"sort_num\" : 19,
            \"code_cd\" : \"DJANGO\",
            \"code_nm\" : \"Django\"
          },
          {
            \"sort_num\" : 20,
            \"code_cd\" : \"SPRING\",
            \"code_nm\" : \"Spring\"
          },
          {
            \"sort_num\" : 21,
            \"code_cd\" : \"IOS\",
            \"code_nm\" : \"iOS\"
          },
          {
            \"sort_num\" : 22,
            \"code_cd\" : \"ANDROID\",
            \"code_nm\" : \"Android\"
          },
          {
            \"sort_num\" : 23,
            \"code_cd\" : \"REACT_NATIVE\",
            \"code_nm\" : \"React-Native\"
          },
          {
            \"sort_num\" : 24,
            \"code_cd\" : \"FLUTTER\",
            \"code_nm\" : \"Flutter\"
          },
          {
            \"sort_num\" : 36,
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
            \"sort_num\" : 46,
            \"code_cd\" : \"UA\",
            \"code_nm\" : \"UA\"
          },
          {
            \"sort_num\" : 56,
            \"code_cd\" : \"FACEBOOK\",
            \"code_nm\" : \"Facebook\"
          },
          {
            \"sort_num\" : 55,
            \"code_cd\" : \"PREMIERE_PRO\",
            \"code_nm\" : \"Premiere Pro\"
          },
          {
            \"sort_num\" : 54,
            \"code_cd\" : \"AFFTER_EFFECT\",
            \"code_nm\" : \"AfterEffect\"
          },
          {
            \"sort_num\" : 53,
            \"code_cd\" : \"ILLUSTRATOR\",
            \"code_nm\" : \"Illustrator\"
          },
          {
            \"sort_num\" : 52,
            \"code_cd\" : \"PHOTOSHOP\",
            \"code_nm\" : \"Photoshop\"
          },
          {
            \"sort_num\" : 51,
            \"code_cd\" : \"GOOGLE_SPREADSHEET\",
            \"code_nm\" : \"Google Spreadsheet\"
          },
          {
            \"sort_num\" : 50,
            \"code_cd\" : \"EXCEL\",
            \"code_nm\" : \"Excel\"
          },
          {
            \"sort_num\" : 49,
            \"code_cd\" : \"AMPLITUDE\",
            \"code_nm\" : \"Amplitude\"
          },
          {
            \"sort_num\" : 48,
            \"code_cd\" : \"FIREBASE\",
            \"code_nm\" : \"Firebase\"
          },
          {
            \"sort_num\" : 47,
            \"code_cd\" : \"GA4\",
            \"code_nm\" : \"GA4\"
          },
          {
            \"sort_num\" : 57,
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
            \"sort_num\" : 6,
            \"code_cd\" : \"FIGMA\",
            \"code_nm\" : \"Figma\"
          },
          {
            \"sort_num\" : 44,
            \"code_cd\" : \"ILLUSTRATOR\",
            \"code_nm\" : \"Illustrator\"
          },
          {
            \"sort_num\" : 43,
            \"code_cd\" : \"PHOTOSHOP\",
            \"code_nm\" : \"Photoshop\"
          },
          {
            \"sort_num\" : 42,
            \"code_cd\" : \"ZEPLIN\",
            \"code_nm\" : \"Zeplin\"
          },
          {
            \"sort_num\" : 41,
            \"code_cd\" : \"PRINCIPLE\",
            \"code_nm\" : \"Principle\"
          },
          {
            \"sort_num\" : 40,
            \"code_cd\" : \"INVISION\",
            \"code_nm\" : \"Invision\"
          },
          {
            \"sort_num\" : 39,
            \"code_cd\" : \"PROTOPIE\",
            \"code_nm\" : \"Protopie\"
          },
          {
            \"sort_num\" : 38,
            \"code_cd\" : \"ADOBE_XD\",
            \"code_nm\" : \"AdobeXD\"
          },
          {
            \"sort_num\" : 37,
            \"code_cd\" : \"SKETCH\",
            \"code_nm\" : \"Sketch\"
          },
          {
            \"sort_num\" : 45,
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
            \"sort_num\" : 5,
            \"code_cd\" : \"FIGMA\",
            \"code_nm\" : \"Figma\"
          },
          {
            \"sort_num\" : 7,
            \"code_cd\" : \"UA\",
            \"code_nm\" : \"UA\"
          },
          {
            \"sort_num\" : 8,
            \"code_cd\" : \"GA4\",
            \"code_nm\" : \"GA4\"
          },
          {
            \"sort_num\" : 9,
            \"code_cd\" : \"FIREBASE\",
            \"code_nm\" : \"Firebase\"
          },
          {
            \"sort_num\" : 10,
            \"code_cd\" : \"AMPLITUDE\",
            \"code_nm\" : \"Amplitude\"
          },
          {
            \"sort_num\" : 14,
            \"code_cd\" : \"EXCEL\",
            \"code_nm\" : \"Excel\"
          },
          {
            \"sort_num\" : 13,
            \"code_cd\" : \"PYTHON\",
            \"code_nm\" : \"Python\"
          },
          {
            \"sort_num\" : 12,
            \"code_cd\" : \"SQL\",
            \"code_nm\" : \"SQL\"
          },
          {
            \"sort_num\" : 11,
            \"code_cd\" : \"APPSFLYR\",
            \"code_nm\" : \"Appsflyr\"
          },
          {
            \"sort_num\" : 15,
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
  
  public static let profile = """
{
  \"result\" : \"SUCCESS\",
  \"data\" : {
    \"region\" : {
      \"regionCode\" : 1165000000,
      \"regionName\" : \"서울 서초구\"
    },
    \"career\" : \"JUNIOR\",
    \"interesting\" : [
      {
        \"code_cd\": \"FINANCE\",
        \"code_nm\": \"금융\"
      },
      {
        \"code_cd\": \"FATION\",
        \"code_nm\": \"패션\"
      },
      {
        \"code_cd\": \"ENTERTAIN\",
        \"code_nm\": \"예능\"
      },
      {
        \"code_cd\": \"HEALTH\",
        \"code_nm\": \"건강\"
      }
    ],
    \"nickname\" : \"Naveruser\",
    \"role\" : [
       {
         \"code_cd\": \"DEV\",
         \"code_nm\": \"개발자\"
       }
    ],
    \"profile_url\" : \"https://ssl.pstatic.net/static/pwe/address/img_profile.png\",
    \"skills\" : [
      \"iOS\"
    ],
    \"terms\" : null,
    \"auth_type\" : \"NAVER\",
    \"portfolio_url\" : \"\",
    \"push_yn\": \"N\",
    \"active_open_yn\": \"N\"
  },
  \"message\" : null,
  \"error_code\" : null
}
"""
}
